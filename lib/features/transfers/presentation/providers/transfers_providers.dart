import 'dart:async';

import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/core/network/network_providers.dart';
import 'package:vaulta/core/usecase/use_case.dart';
// Presentation-only reads into sibling features (§6.22): the flow needs
// the source account's currency to parse an amount, and a settled
// transfer makes every cached balance stale. Both stay at the
// presentation layer — no domain or data coupling crosses features.
import 'package:vaulta/features/accounts/presentation/providers/accounts_providers.dart';
import 'package:vaulta/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:vaulta/features/transactions/presentation/providers/transactions_providers.dart';
import 'package:vaulta/features/transfers/data/datasources/transfers_remote_data_source.dart';
import 'package:vaulta/features/transfers/data/repositories/transfers_repository_impl.dart';
import 'package:vaulta/features/transfers/domain/entities/beneficiary.dart';
import 'package:vaulta/features/transfers/domain/entities/transfer.dart';
import 'package:vaulta/features/transfers/domain/repositories/transfers_repository.dart';
import 'package:vaulta/features/transfers/domain/usecases/transfers_usecases.dart';
import 'package:vaulta/features/transfers/presentation/forms/transfer_inputs.dart';

part 'transfers_providers.g.dart';

/// Composition point for the transfers slice. Tests override this with a
/// mocked [TransfersRepository] — the same seam as every feature.
@riverpod
TransfersRepository transfersRepository(Ref ref) {
  return TransfersRepositoryImpl(
    remote: TransfersRemoteDataSource(ref.watch(dioProvider)),
  );
}

/// Saved payees for the recipient picker.
@riverpod
class BeneficiariesController extends _$BeneficiariesController {
  var _disposed = false;

  @override
  AsyncValue<List<Beneficiary>> build() {
    _disposed = false;
    ref.onDispose(() => _disposed = true);
    unawaited(Future<void>.microtask(_load));
    return const AsyncLoading();
  }

  Future<Failure?> refresh() => _load();

  Future<Failure?> _load() async {
    final result = await GetBeneficiaries(ref.read(transfersRepositoryProvider))
        .call(const NoParams());
    if (_disposed) return null;
    return result.fold<Failure?>(
      onSuccess: (beneficiaries) {
        state = AsyncData(beneficiaries);
        return null;
      },
      onFailure: (failure) {
        if (!state.hasValue) {
          state = AsyncError(failure, failure.stackTrace ?? StackTrace.current);
        }
        return failure;
      },
    );
  }
}

/// The four surfaces of the send-money flow.
enum TransferStep { recipient, amount, review, receipt }

/// Everything the flow needs to render, in one immutable value.
@immutable
class TransferFlowState {
  const TransferFlowState({
    this.step = TransferStep.recipient,
    this.sourceAccountId,
    this.destination,
    this.amount = const AmountInput.pure(),
    this.iban = const IbanInput.pure(),
    this.holderName = const HolderNameInput.pure(),
    this.note = '',
    this.scheduledFor,
    this.quote,
    this.transfer,
    this.busy = false,
  });

  final TransferStep step;
  final String? sourceAccountId;
  final TransferDestination? destination;
  final AmountInput amount;

  /// Only used while composing an [IbanDestination]; ignored otherwise.
  final IbanInput iban;
  final HolderNameInput holderName;

  final String note;
  final DateTime? scheduledFor;

  /// The server's priced draft, present from the review step onwards.
  final TransferQuote? quote;

  /// The settled transfer, present only on the receipt.
  final Transfer? transfer;

  /// A quote or confirm is in flight. Also the double-tap guard.
  final bool busy;

  bool get canQuote =>
      sourceAccountId != null && destination != null && amount.isValid;

  TransferFlowState copyWith({
    TransferStep? step,
    String? sourceAccountId,
    TransferDestination? destination,
    AmountInput? amount,
    IbanInput? iban,
    HolderNameInput? holderName,
    String? note,
    DateTime? scheduledFor,
    bool clearScheduledFor = false,
    TransferQuote? quote,
    bool clearQuote = false,
    Transfer? transfer,
    bool? busy,
  }) {
    return TransferFlowState(
      step: step ?? this.step,
      sourceAccountId: sourceAccountId ?? this.sourceAccountId,
      destination: destination ?? this.destination,
      amount: amount ?? this.amount,
      iban: iban ?? this.iban,
      holderName: holderName ?? this.holderName,
      note: note ?? this.note,
      scheduledFor:
          clearScheduledFor ? null : (scheduledFor ?? this.scheduledFor),
      quote: clearQuote ? null : (quote ?? this.quote),
      transfer: transfer ?? this.transfer,
      busy: busy ?? this.busy,
    );
  }
}

/// Drives the recipient → amount → review → receipt flow.
///
/// The confirm is **pessimistic**, unlike Phase 7's optimistic freeze: a
/// transfer is only shown as done once the server says it is. Nothing
/// about a money movement may be guessed at and rolled back.
///
/// Every edit upstream of the review step clears the quote, so a stale
/// price can never be the thing the user confirms.
@riverpod
class TransferFlow extends _$TransferFlow {
  var _disposed = false;

  @override
  TransferFlowState build() {
    _disposed = false;
    ref.onDispose(() => _disposed = true);
    return const TransferFlowState();
  }

  void selectSource(String accountId) {
    state = state.copyWith(sourceAccountId: accountId, clearQuote: true);
  }

  void selectDestination(TransferDestination destination) {
    state = state.copyWith(destination: destination, clearQuote: true);
  }

  void amountChanged(String value) {
    state = state.copyWith(
      amount: AmountInput.dirty(value),
      clearQuote: true,
    );
  }

  void ibanChanged(String value) {
    state = state.copyWith(iban: IbanInput.dirty(value), clearQuote: true);
  }

  void holderNameChanged(String value) {
    state = state.copyWith(
      holderName: HolderNameInput.dirty(value),
      clearQuote: true,
    );
  }

  void noteChanged(String value) => state = state.copyWith(note: value);

  void scheduleChanged(DateTime? date) {
    state = date == null
        ? state.copyWith(clearScheduledFor: true, clearQuote: true)
        : state.copyWith(scheduledFor: date, clearQuote: true);
  }

  void goTo(TransferStep step) => state = state.copyWith(step: step);

  /// Steps back one surface. The receipt is terminal — there is nothing
  /// to go back to once money has moved.
  void back() {
    final previous = switch (state.step) {
      TransferStep.recipient || TransferStep.receipt => null,
      TransferStep.amount => TransferStep.recipient,
      TransferStep.review => TransferStep.amount,
    };
    if (previous != null) state = state.copyWith(step: previous);
  }

  /// Commits the typed IBAN and holder name as the destination.
  /// Returns `false` when either is invalid.
  bool useTypedIban() {
    final iban = IbanInput.dirty(state.iban.value);
    final holder = HolderNameInput.dirty(state.holderName.value);
    state = state.copyWith(iban: iban, holderName: holder);
    final parsed = iban.iban;
    if (parsed == null || !holder.isValid) return false;
    selectDestination(
      IbanDestination(iban: parsed, holderName: holder.value.trim()),
    );
    return true;
  }

  /// Prices the transfer and advances to review. Returns a [Failure] for
  /// a snackbar, or `null` on success.
  Future<Failure?> requestQuote() async {
    final accountId = state.sourceAccountId;
    final destination = state.destination;
    if (accountId == null || destination == null || state.busy) return null;

    final amount = _amountFor(accountId);
    if (amount == null) {
      // Re-dirty so the field renders its error instead of failing mute.
      state = state.copyWith(amount: AmountInput.dirty(state.amount.value));
      return null;
    }

    state = state.copyWith(busy: true);
    final result = await CreateTransfer(_repository).call(
      TransferRequest(
        sourceAccountId: accountId,
        destination: destination,
        amount: amount,
        note: state.note.trim().isEmpty ? null : state.note.trim(),
        scheduledFor: state.scheduledFor,
      ),
    );
    if (_disposed) return null;

    return result.fold<Failure?>(
      onSuccess: (quote) {
        state = state.copyWith(
          busy: false,
          quote: quote,
          step: TransferStep.review,
        );
        return null;
      },
      onFailure: (failure) {
        state = state.copyWith(busy: false);
        return failure;
      },
    );
  }

  /// Executes the quoted transfer. Pessimistic: the receipt appears only
  /// after the server confirms.
  ///
  /// The quote's idempotency key is replayed verbatim, so a retry — from
  /// the retry interceptor or from the user tapping again after a
  /// timeout — settles onto the same transfer rather than sending twice.
  Future<Failure?> confirm() async {
    final quote = state.quote;
    if (quote == null || state.busy) return null;

    state = state.copyWith(busy: true);
    final result = await ConfirmTransfer(_repository).call(
      ConfirmTransferParams(
        transferId: quote.id,
        idempotencyKey: quote.idempotencyKey,
      ),
    );
    if (_disposed) return null;

    return result.fold<Failure?>(
      onSuccess: (transfer) {
        state = state.copyWith(
          busy: false,
          transfer: transfer,
          step: TransferStep.receipt,
        );
        _invalidateBalances();
        return null;
      },
      onFailure: (failure) {
        state = state.copyWith(busy: false);
        return failure;
      },
    );
  }

  void reset() => state = const TransferFlowState();

  /// Money moved, so every cached balance and feed is stale. Invalidating
  /// rather than patching keeps the server the single source of truth —
  /// the same reasoning that makes the confirm pessimistic.
  void _invalidateBalances() {
    ref
      ..invalidate(accountsControllerProvider)
      ..invalidate(dashboardControllerProvider)
      ..invalidate(transactionsFeedControllerProvider);
  }

  Money? _amountFor(String accountId) {
    final account = ref.read(accountByIdProvider(accountId));
    if (account == null) return null;
    return AmountInput.dirty(state.amount.value).moneyIn(account.currency);
  }

  TransfersRepository get _repository => ref.read(transfersRepositoryProvider);
}
