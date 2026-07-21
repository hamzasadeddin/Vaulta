import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/core/network/network_providers.dart';
import 'package:vaulta/core/security/biometric_service.dart';
import 'package:vaulta/core/usecase/use_case.dart';
import 'package:vaulta/features/cards/data/datasources/cards_remote_data_source.dart';
import 'package:vaulta/features/cards/data/repositories/cards_repository_impl.dart';
import 'package:vaulta/features/cards/domain/entities/bank_card.dart';
import 'package:vaulta/features/cards/domain/repositories/cards_repository.dart';
import 'package:vaulta/features/cards/domain/usecases/cards_usecases.dart';

part 'cards_providers.g.dart';

/// Composition point for the cards slice. Tests override this with a
/// mocked [CardsRepository] — the same seam as every feature.
@riverpod
CardsRepository cardsRepository(Ref ref) {
  return CardsRepositoryImpl(
    remote: CardsRemoteDataSource(ref.watch(dioProvider)),
  );
}

/// The card list plus its mutations. Holds `AsyncValue` manually (the
/// dashboard/accounts/transactions pattern): data survives a failed
/// refresh, and mutations edit the value in place.
///
/// Freeze/unfreeze is the codebase's first *optimistic* mutation: the flip
/// lands in state immediately, the server call runs behind it, and the
/// controller either reconciles with the returned card or rolls back to
/// the pre-mutation snapshot on failure — all as `Result` values, never
/// thrown.
@riverpod
class CardsController extends _$CardsController {
  var _disposed = false;
  var _requestId = 0;

  /// Cards with a freeze/unfreeze in flight. A second toggle on the same
  /// card no-ops until the first reconciles — the optimistic value is
  /// already on screen, so there is nothing for a re-tap to add except a
  /// race.
  final _mutating = <String>{};

  @override
  AsyncValue<List<BankCard>> build() {
    _disposed = false;
    ref.onDispose(() => _disposed = true);
    unawaited(Future<void>.microtask(_load));
    return const AsyncLoading();
  }

  /// Pull-to-refresh / error retry. Returns the failure (for a snackbar)
  /// instead of clobbering already-visible data with an error state.
  Future<Failure?> refresh() => _load();

  /// Optimistically flips [cardId]'s frozen state. Returns the failure
  /// after rolling back, `null` on success or no-op.
  Future<Failure?> toggleFrozen(String cardId) async {
    final cards = state.value;
    if (cards == null || _mutating.contains(cardId)) return null;
    BankCard? before;
    for (final card in cards) {
      if (card.id == cardId) before = card;
    }
    final snapshot = before;
    if (snapshot == null) return null;
    final frozen = !snapshot.isFrozen;

    _mutating.add(cardId);
    _replace(
      snapshot.copyWith(
        status: frozen ? CardStatus.frozen : CardStatus.active,
      ),
    );

    final result = await SetCardFrozen(_repository).call(
      SetCardFrozenParams(cardId: cardId, frozen: frozen),
    );
    _mutating.remove(cardId);
    if (_disposed) return null;

    return result.fold<Failure?>(
      onSuccess: (card) {
        _replace(card);
        return null;
      },
      onFailure: (failure) {
        // Roll back to the pre-mutation snapshot of this one card. If a
        // refresh landed in between, the next load re-asserts server
        // truth anyway — the snapshot is only ever a frame-level fix.
        _replace(snapshot);
        return failure;
      },
    );
  }

  /// Replaces both limits on [cardId]. Not optimistic: the server
  /// validates (positive, daily ≤ monthly), so the form waits for the
  /// verdict instead of showing values that may bounce.
  Future<Failure?> updateLimits({
    required String cardId,
    required Money daily,
    required Money monthly,
  }) async {
    final result = await UpdateCardLimits(_repository).call(
      UpdateCardLimitsParams(cardId: cardId, daily: daily, monthly: monthly),
    );
    if (_disposed) return null;
    return result.fold<Failure?>(
      onSuccess: (card) {
        _replace(card);
        return null;
      },
      onFailure: (failure) => failure,
    );
  }

  Future<Failure?> _load() async {
    final requestId = ++_requestId;
    final result = await GetCards(_repository).call(const NoParams());
    if (_disposed || requestId != _requestId) return null;

    return result.fold<Failure?>(
      onSuccess: (cards) {
        state = AsyncData(cards);
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

  void _replace(BankCard card) {
    final cards = state.value;
    if (cards == null) return;
    state = AsyncData([
      for (final existing in cards)
        if (existing.id == card.id) card else existing,
    ]);
  }

  CardsRepository get _repository => ref.read(cardsRepositoryProvider);
}

/// Lookup into the loaded list — the detail surface resolves its card here
/// instead of refetching (the `accountById` pattern).
@riverpod
BankCard? cardById(Ref ref, String cardId) {
  final cards = ref.watch(cardsControllerProvider).value;
  if (cards == null) return null;
  for (final card in cards) {
    if (card.id == cardId) return card;
  }
  return null;
}

/// Reveal lifecycle for one card's PAN: hidden (`AsyncData(null)`) →
/// loading → revealed (`AsyncData(pan)`) → auto-hidden after
/// [autoHideAfter]. The secret only ever lives in this provider's state,
/// and the reveal itself is gated behind the biometric service.
@riverpod
class RevealedPan extends _$RevealedPan {
  var _disposed = false;
  Timer? _timer;

  /// How long a revealed PAN stays on screen before hiding itself.
  static const autoHideAfter = Duration(seconds: 30);

  @override
  AsyncValue<CardPan?> build(String cardId) {
    _disposed = false;
    ref.onDispose(() {
      _disposed = true;
      _timer?.cancel();
    });
    return const AsyncData(null);
  }

  /// Biometric-gated reveal. Declining the prompt quietly stays hidden —
  /// a user cancel is not an error. A failed fetch returns its [Failure]
  /// for a snackbar.
  Future<Failure?> reveal() async {
    if (state.isLoading || state.value != null) return null;

    final granted = await ref
        .read(biometricServiceProvider)
        .authenticate(reason: 'Confirm it\u2019s you to reveal card details');
    if (_disposed || !granted) return null;

    state = const AsyncLoading();
    final result =
        await RevealCardPan(ref.read(cardsRepositoryProvider)).call(cardId);
    if (_disposed) return null;

    return result.fold<Failure?>(
      onSuccess: (pan) {
        state = AsyncData(pan);
        _timer?.cancel();
        _timer = Timer(autoHideAfter, hide);
        return null;
      },
      onFailure: (failure) {
        state = const AsyncData(null);
        return failure;
      },
    );
  }

  void hide() {
    _timer?.cancel();
    if (_disposed) return;
    state = const AsyncData(null);
  }
}
