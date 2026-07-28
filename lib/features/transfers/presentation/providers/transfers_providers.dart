import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/core/network/network_providers.dart';
import 'package:vaulta/core/result/result.dart';
import 'package:vaulta/core/usecase/use_case.dart';
// Presentation-only reads into sibling features (§6.22): the flow needs
// the source account's currency to parse an amount, and a settled
// transfer makes every cached balance stale. Both stay at the
// presentation layer — no domain or data coupling crosses features.
import 'package:vaulta/features/accounts/presentation/providers/accounts_providers.dart';
import 'package:vaulta/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:vaulta/features/savings/presentation/providers/pots_providers.dart';
import 'package:vaulta/features/transactions/presentation/providers/transactions_providers.dart';
import 'package:vaulta/features/transfers/data/datasources/transfers_remote_data_source.dart';
import 'package:vaulta/features/transfers/data/repositories/transfers_repository_impl.dart';
import 'package:vaulta/features/transfers/domain/entities/beneficiary.dart';
import 'package:vaulta/features/transfers/domain/entities/transfer.dart';
import 'package:vaulta/features/transfers/domain/repositories/transfers_repository.dart';
import 'package:vaulta/features/transfers/domain/usecases/transfers_usecases.dart';
import 'package:vaulta/features/transfers/presentation/forms/transfer_inputs.dart';
import 'package:vaulta/features/transfers/presentation/providers/outbox_providers.dart';

part 'transfers_providers.g.dart';

/// Clock seam for the quote lock. A `Provider` rather than a bare
/// `DateTime.now` so a test can walk a 90-second FX hold to its last
/// second without waiting 90 seconds — provider overrides are the only
/// injection seam in this codebase.
///
/// Hand-written rather than `@riverpod`: it holds no state and needs no
/// disposal, and `overrideWithValue` on a plain `Provider` is the same
/// shape `core/network` already uses for its own seams.
///
/// Phase 9b widened its remit: the outbox's backoff, its due-check and
/// its wake timer all read the same clock, so overriding this one
/// provider makes the whole queue deterministic in tests.
final transferClockProvider = Provider<DateTime Function()>(
  (ref) => DateTime.now,
);

/// Composition point for the transfers slice. Tests override this with a
/// mocked [TransfersRepository] — the same seam as every feature.
@riverpod
TransfersRepository transfersRepository(Ref ref) {
  return TransfersRepositoryImpl(
    remote: TransfersRemoteDataSource(ref.watch(dioProvider)),
    clock: ref.watch(transferClockProvider),
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

/// The five surfaces of the send-money flow.
///
/// [queued] is Phase 9b's addition and it is a *terminal* surface, not an
/// error state: the user authorised the transfer, the bank was
/// unreachable, and the instruction is now durable. It sits beside
/// [receipt] rather than replacing it because the two say different
/// things — one is "this happened", the other is "this will".
enum TransferStep { recipient, amount, review, receipt, queued }

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
    this.request,
    this.quoteRemaining,
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

  /// The request that produced [quote], kept in step with it.
  ///
  /// Needed because a queued confirm may later have to be *re-priced*,
  /// and a re-quote is a new draft rather than a refreshed one (§38) —
  /// so what has to survive is the original request, not the dead quote.
  final TransferRequest? request;

  /// Time left on the quote's price lock, ticked down once a second.
  /// `null` whenever nothing is held — no quote yet, or a same-currency
  /// quote, which has no rate that can move and so never expires.
  final Duration? quoteRemaining;

  /// The settled transfer, present only on the receipt.
  final Transfer? transfer;

  /// A quote or confirm is in flight. Also the double-tap guard.
  final bool busy;

  bool get canQuote =>
      sourceAccountId != null && destination != null && amount.isValid;

  /// The held price has run out. Distinct from `quoteRemaining == null`,
  /// which means there was never a lock to begin with — an unlocked quote
  /// is perfectly confirmable, an expired one is not.
  bool get quoteExpired => quote != null && quoteRemaining == Duration.zero;

  /// Whether a countdown should be on screen at all.
  bool get quoteIsLocked => quoteRemaining != null;

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
    TransferRequest? request,
    Duration? quoteRemaining,
    bool clearQuoteRemaining = false,
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
      // The request is the quote's twin — it is what produced it and
      // what would re-produce it. Carrying one without the other would
      // let a re-price run against details the user has since edited.
      request: clearQuote ? null : (request ?? this.request),
      // The countdown belongs to the quote, so it is never carried past
      // one: dropping the quote without dropping its remaining time would
      // leave a countdown ticking against a price that no longer exists.
      quoteRemaining: clearQuote || clearQuoteRemaining
          ? null
          : (quoteRemaining ?? this.quoteRemaining),
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
/// Phase 9b adds one exception, and it is not a softening of that rule:
/// when the *transport* fails the flow still never claims the money
/// moved — it says the instruction is saved and will be delivered. The
/// receipt remains reserved for a server answer.
///
/// Every edit upstream of the review step clears the quote, so a stale
/// price can never be the thing the user confirms.
@riverpod
class TransferFlow extends _$TransferFlow {
  var _disposed = false;
  Timer? _lockTimer;

  @override
  TransferFlowState build() {
    _disposed = false;
    ref.onDispose(() {
      _disposed = true;
      _lockTimer?.cancel();
      _lockTimer = null;
    });
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

  /// Steps back one surface. The receipt and the queued notice are both
  /// terminal — there is nothing to go back to once the instruction has
  /// been either executed or durably accepted.
  void back() {
    final previous = switch (state.step) {
      TransferStep.recipient ||
      TransferStep.receipt ||
      TransferStep.queued =>
        null,
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

    return _quoteFor(
      TransferRequest(
        sourceAccountId: accountId,
        destination: destination,
        amount: amount,
        note: state.note.trim().isEmpty ? null : state.note.trim(),
        scheduledFor: state.scheduledFor,
      ),
    );
  }

  /// Re-opens the flow on the review step for a transfer that was queued
  /// and then refused — the "get a new price" arm of §10's policy.
  ///
  /// Seeds directly from the stored [TransferRequest] rather than
  /// replaying the UI's inputs, because the account list may not be
  /// loaded when the user acts on the queue and the request already
  /// carries an exact [Money]. The caller discards the outbox entry: the
  /// dead draft must never be confirmable again (§38), and nothing has
  /// moved, so there is nothing to reconcile.
  Future<Failure?> resumeFrom(TransferRequest request) {
    state = TransferFlowState(
      step: TransferStep.review,
      sourceAccountId: request.sourceAccountId,
      destination: request.destination,
      amount: AmountInput.dirty(request.amount.amount.toString()),
      note: request.note ?? '',
      scheduledFor: request.scheduledFor,
    );
    return _quoteFor(request);
  }

  /// Executes the quoted transfer. Pessimistic: the receipt appears only
  /// after the server confirms.
  ///
  /// The quote's idempotency key is replayed verbatim, so a retry — from
  /// the retry interceptor, from the user tapping again after a timeout,
  /// or from the outbox days later — settles onto the same transfer
  /// rather than sending twice.
  Future<Failure?> confirm() async {
    final quote = state.quote;
    final request = state.request;
    if (quote == null || state.busy || state.quoteExpired) return null;

    state = state.copyWith(busy: true);
    final result = await ConfirmTransfer(_repository).call(
      ConfirmTransferParams(
        transferId: quote.id,
        idempotencyKey: quote.idempotencyKey,
      ),
    );
    if (_disposed) return null;

    switch (result) {
      case Success<Transfer, Failure>(:final value):
        _lockTimer?.cancel();
        _lockTimer = null;
        state = state.copyWith(
          busy: false,
          transfer: value,
          step: TransferStep.receipt,
        );
        _invalidateBalances();
        return null;
      case Failed<Transfer, Failure>(:final failure):
        return _afterFailedConfirm(failure, quote: quote, request: request);
    }
  }

  void reset() {
    _lockTimer?.cancel();
    _lockTimer = null;
    // The deferred caller in `TransferFlowScreen` fires after the screen has
    // gone, and this provider is auto-dispose — so by then the notifier may
    // already be torn down. Cancelling the ticker is always safe; writing
    // state to a disposed notifier throws.
    if (_disposed) return;
    state = const TransferFlowState();
  }

  /// Re-prices the same recipient and amount, staying on review.
  ///
  /// A re-quote is a genuinely new draft — new id, new idempotency key,
  /// new lock — and not a refresh of the old one. That is the point: the
  /// expired key must never be confirmable again, and reusing it would
  /// hand the user the old price under a new countdown.
  Future<Failure?> refreshQuote() => requestQuote();

  /// Recomputes the time left on the lock.
  ///
  /// Public because the periodic timer is production's only caller and a
  /// test's is the test itself — driving a countdown through real
  /// `Timer`s would mean sleeping through it.
  @visibleForTesting
  void tick() {
    final quote = state.quote;
    if (quote == null || !quote.isLocked) return;
    final remaining = quote.remainingAt(_now());
    if (remaining == state.quoteRemaining) return;
    state = state.copyWith(quoteRemaining: remaining);
    if (remaining == Duration.zero) {
      _lockTimer?.cancel();
      _lockTimer = null;
    }
  }

  /// Decides what a failed confirm means for the flow.
  ///
  /// Only a *transport* failure is queueable. Everything else is an
  /// answer from the bank: a 422 will be refused identically in an hour,
  /// a 409 means the price is already dead, and a 401 means the session
  /// is. Queueing those would convert a clear, actionable error into a
  /// delayed one — the opposite of what an outbox is for.
  Future<Failure?> _afterFailedConfirm(
    Failure failure, {
    required TransferQuote quote,
    required TransferRequest? request,
  }) async {
    final queueable = failure is NetworkFailure || failure is TimeoutFailure;
    if (!queueable || request == null) {
      state = state.copyWith(busy: false);
      return failure;
    }

    final queued = await ref
        .read(outboxControllerProvider.notifier)
        .enqueue(quote: quote, request: request);
    if (_disposed) return null;

    if (!queued) {
      // The queue itself could not be written. Report the original
      // network failure rather than a reassurance nothing can back.
      state = state.copyWith(busy: false);
      return failure;
    }

    _lockTimer?.cancel();
    _lockTimer = null;
    // Balances are deliberately *not* invalidated: nothing has moved,
    // and refreshing them here would imply otherwise.
    state = state.copyWith(busy: false, step: TransferStep.queued);
    return null;
  }

  Future<Failure?> _quoteFor(TransferRequest request) async {
    if (state.busy) return null;
    state = state.copyWith(busy: true);
    final result = await CreateTransfer(_repository).call(request);
    if (_disposed) return null;

    return result.fold<Failure?>(
      onSuccess: (quote) {
        final remaining = quote.remainingAt(_now());
        state = state.copyWith(
          busy: false,
          quote: quote,
          request: request,
          quoteRemaining: remaining,
          // An unlocked replacement has to actively clear the old
          // countdown: `??` would inherit the dead quote's `Duration.zero`
          // and the new price would render as expired on arrival.
          clearQuoteRemaining: remaining == null,
          step: TransferStep.review,
        );
        _startLockTimer(quote);
        return null;
      },
      onFailure: (failure) {
        state = state.copyWith(busy: false);
        return failure;
      },
    );
  }

  /// Ticks the countdown once a second while a price is held. Unlocked
  /// quotes get no timer at all rather than a timer that never fires.
  void _startLockTimer(TransferQuote quote) {
    _lockTimer?.cancel();
    _lockTimer = null;
    if (!quote.isLocked) return;
    _lockTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        if (_disposed) return;
        tick();
      },
    );
  }

  DateTime Function() get _now => ref.read(transferClockProvider);

  /// Money moved, so every cached balance and feed is stale. Invalidating
  /// rather than patching keeps the server the single source of truth —
  /// the same reasoning that makes the confirm pessimistic.
  void _invalidateBalances() {
    ref
      ..invalidate(accountsControllerProvider)
      ..invalidate(dashboardControllerProvider)
      ..invalidate(transactionsFeedControllerProvider)
      // A pot deposit or withdrawal is a transfer, so a settled one leaves
      // pot balances stale too (§12.2). Harmless for non-pot transfers —
      // the list simply refetches unchanged.
      ..invalidate(potsControllerProvider);
  }

  Money? _amountFor(String accountId) {
    final account = ref.read(accountByIdProvider(accountId));
    if (account == null) return null;
    return AmountInput.dirty(state.amount.value).moneyIn(account.currency);
  }

  TransfersRepository get _repository => ref.read(transfersRepositoryProvider);
}
