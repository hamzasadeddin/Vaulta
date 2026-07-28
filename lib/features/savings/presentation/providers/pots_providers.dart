import 'dart:async';

import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/core/network/network_providers.dart';
import 'package:vaulta/core/usecase/use_case.dart';
import 'package:vaulta/features/savings/data/datasources/pots_remote_data_source.dart';
import 'package:vaulta/features/savings/data/repositories/pots_repository_impl.dart';
import 'package:vaulta/features/savings/domain/entities/pot.dart';
import 'package:vaulta/features/savings/domain/entities/round_up.dart';
import 'package:vaulta/features/savings/domain/repositories/pots_repository.dart';
import 'package:vaulta/features/savings/domain/usecases/pots_usecases.dart';
// The round-up computation takes a plain transaction list; the card feeds
// it from the activity feed it watches, so no cross-feature provider
// dependency lives here.
import 'package:vaulta/features/transactions/domain/entities/transaction.dart';

part 'pots_providers.g.dart';

/// Composition point for the savings slice. Tests override this with a
/// mocked [PotsRepository] — the same seam as every feature.
@riverpod
PotsRepository potsRepository(Ref ref) {
  return PotsRepositoryImpl(
    remote: PotsRemoteDataSource(ref.watch(dioProvider)),
  );
}

/// The user's savings pots. Auto-dispose, and invalidated by the transfer
/// flow when a deposit or withdrawal settles — the same "money moved,
/// balances are stale" reasoning that invalidates the account list.
@riverpod
class PotsController extends _$PotsController {
  var _disposed = false;

  @override
  AsyncValue<List<Pot>> build() {
    _disposed = false;
    ref.onDispose(() => _disposed = true);
    unawaited(Future<void>.microtask(_load));
    return const AsyncLoading();
  }

  Future<Failure?> refresh() => _load();

  /// Opens a new pot, then reloads so it appears. Returns a [Failure] for a
  /// snackbar, or `null` on success.
  Future<Failure?> createPot({
    required String accountId,
    required String name,
    Money? goal,
  }) async {
    final result = await CreatePot(ref.read(potsRepositoryProvider)).call(
      CreatePotParams(accountId: accountId, name: name, goal: goal),
    );
    if (_disposed) return null;
    return result.fold<Failure?>(
      onSuccess: (_) {
        unawaited(_load());
        return null;
      },
      onFailure: (failure) => failure,
    );
  }

  Future<Failure?> _load() async {
    final result =
        await GetPots(ref.read(potsRepositoryProvider)).call(const NoParams());
    if (_disposed) return null;
    return result.fold<Failure?>(
      onSuccess: (pots) {
        state = AsyncData(pots);
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

/// The pending round-up sweep: how much spare change recent spending has
/// accrued, and the pot it would go to.
///
/// The [pot] is the (at most one) round-ups-enabled pot; [total] is zero
/// and [pot] `null` until both the pots and the activity feed have loaded.
@immutable
class RoundUpSummary {
  const RoundUpSummary({required this.total, required this.count, this.pot});

  /// Total spare change accrued, in [pot]'s currency (or USD as a neutral
  /// zero when there is no enabled pot).
  final Money total;

  /// How many spends actually contributed a round-up.
  final int count;

  /// The pot the sweep would fund, or `null` when round-ups are off.
  final Pot? pot;

  /// There is something to sweep and somewhere to sweep it.
  bool get hasPending => pot != null && total.isPositive;
}

/// Pure computation of the pending round-up sweep from the pots and the
/// loaded activity feed.
///
/// Deliberately **not** a provider. A derived provider watching
/// [potsControllerProvider] recomputes synchronously when a Savings widget
/// subscription resumes during the shell's `LayoutBuilder` pass, which
/// schedules a build mid-build (`setState during build`). Having the card
/// compute this from the two controllers it already watches keeps it a
/// plain widget rebuild, which is safe.
RoundUpSummary computeRoundUpSummary({
  required List<Pot> pots,
  required List<Transaction> transactions,
}) {
  Pot? target;
  for (final pot in pots) {
    if (pot.roundUpsEnabled) {
      target = pot;
      break;
    }
  }

  final currency = target?.currency ?? Currency.usd;
  const rule = RoundUpRule();
  const accrual = RoundUpAccrual(rule);

  final spends = <Money>[
    for (final txn in transactions)
      if (!txn.isCredit &&
          txn.category != TransactionCategory.transfer &&
          txn.amount.currency == currency)
        txn.amount.abs(),
  ];
  final contributing =
      spends.where((spend) => rule.remainderFor(spend).isPositive).length;

  return RoundUpSummary(
    total: accrual.accrue(spends, currency),
    count: contributing,
    pot: target,
  );
}
