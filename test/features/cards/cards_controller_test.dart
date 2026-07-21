import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/core/result/result.dart';
import 'package:vaulta/core/security/biometric_service.dart';
import 'package:vaulta/features/cards/domain/entities/bank_card.dart';
import 'package:vaulta/features/cards/domain/repositories/cards_repository.dart';
import 'package:vaulta/features/cards/presentation/providers/cards_providers.dart';

class _MockRepository extends Mock implements CardsRepository {}

class _FakeBiometrics implements BiometricService {
  _FakeBiometrics({required bool granted}) : _granted = granted;

  final bool _granted;
  int calls = 0;

  @override
  Future<bool> authenticate({required String reason}) async {
    calls++;
    return _granted;
  }
}

CardLimits _limits() => CardLimits(
      daily: Money.parse('500.00', Currency.usd),
      monthly: Money.parse('12000.00', Currency.usd),
      spentToday: Money.parse('0.00', Currency.usd),
      spentThisMonth: Money.parse('0.00', Currency.usd),
    );

BankCard _card({
  String id = 'crd_1',
  CardStatus status = CardStatus.active,
}) =>
    BankCard(
      id: id,
      accountId: 'acc_chk',
      label: 'Everyday',
      type: CardType.physical,
      network: CardNetwork.visa,
      status: status,
      panLast4: '4242',
      expiryMonth: 9,
      expiryYear: 2028,
      limits: _limits(),
    );

const _pan = CardPan(
  pan: '4242424242424242',
  cvv: '123',
  expiryMonth: 9,
  expiryYear: 2028,
);

void main() {
  late _MockRepository repository;

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  setUpAll(() {
    registerFallbackValue(Money.zero(Currency.usd));
  });

  setUp(() {
    repository = _MockRepository();
    when(repository.getCards)
        .thenAnswer((_) async => Result.success([_card()]));
  });

  ProviderContainer makeContainer({BiometricService? biometrics}) {
    final container = ProviderContainer(
      overrides: [
        cardsRepositoryProvider.overrideWithValue(repository),
        if (biometrics != null)
          biometricServiceProvider.overrideWithValue(biometrics),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('CardsController', () {
    test('loads the card list', () async {
      final container = makeContainer();
      final sub = container.listen(cardsControllerProvider, (_, __) {});
      expect(sub.read().isLoading, isTrue);

      await settle();
      await settle();

      expect(sub.read().value?.single.label, 'Everyday');
    });

    test(
        'toggleFrozen is optimistic — the flip lands before the server '
        'answers', () async {
      final completer = Completer<Result<BankCard, Failure>>();
      when(
        () => repository.setCardFrozen(
          cardId: any(named: 'cardId'),
          frozen: any(named: 'frozen'),
        ),
      ).thenAnswer((_) => completer.future);

      final container = makeContainer()
        ..listen(cardsControllerProvider, (_, __) {});
      await settle();
      await settle();

      final future = container
          .read(cardsControllerProvider.notifier)
          .toggleFrozen('crd_1');
      // Not yet reconciled with the server, but already frozen on screen.
      expect(
        container.read(cardsControllerProvider).value!.single.isFrozen,
        isTrue,
      );

      completer.complete(
        Result.success(_card(status: CardStatus.frozen)),
      );
      await future;
      expect(
        container.read(cardsControllerProvider).value!.single.isFrozen,
        isTrue,
      );
    });

    test('a failed toggle rolls back and returns the failure', () async {
      when(
        () => repository.setCardFrozen(
          cardId: any(named: 'cardId'),
          frozen: any(named: 'frozen'),
        ),
      ).thenAnswer((_) async => const Result.failure(NetworkFailure()));

      final container = makeContainer()
        ..listen(cardsControllerProvider, (_, __) {});
      await settle();
      await settle();

      final failure = await container
          .read(cardsControllerProvider.notifier)
          .toggleFrozen('crd_1');

      expect(failure, isA<NetworkFailure>());
      expect(
        container.read(cardsControllerProvider).value!.single.isFrozen,
        isFalse,
      );
    });

    test('a second toggle while one is in flight is a no-op', () async {
      final completer = Completer<Result<BankCard, Failure>>();
      when(
        () => repository.setCardFrozen(
          cardId: any(named: 'cardId'),
          frozen: any(named: 'frozen'),
        ),
      ).thenAnswer((_) => completer.future);

      final container = makeContainer()
        ..listen(cardsControllerProvider, (_, __) {});
      await settle();
      await settle();

      final notifier = container.read(cardsControllerProvider.notifier);
      final first = notifier.toggleFrozen('crd_1');
      await notifier.toggleFrozen('crd_1'); // ignored — one in flight

      completer.complete(Result.success(_card(status: CardStatus.frozen)));
      await first;

      verify(
        () => repository.setCardFrozen(cardId: 'crd_1', frozen: true),
      ).called(1);
    });

    test('updateLimits replaces the card on success', () async {
      final updated = _card().copyWith(
        limits: CardLimits(
          daily: Money.parse('300.00', Currency.usd),
          monthly: Money.parse('9000.00', Currency.usd),
          spentToday: Money.zero(Currency.usd),
          spentThisMonth: Money.zero(Currency.usd),
        ),
      );
      when(
        () => repository.updateCardLimits(
          cardId: any(named: 'cardId'),
          daily: any(named: 'daily'),
          monthly: any(named: 'monthly'),
        ),
      ).thenAnswer((_) async => Result.success(updated));

      final container = makeContainer()
        ..listen(cardsControllerProvider, (_, __) {});
      await settle();
      await settle();

      final failure =
          await container.read(cardsControllerProvider.notifier).updateLimits(
                cardId: 'crd_1',
                daily: Money.parse('300.00', Currency.usd),
                monthly: Money.parse('9000.00', Currency.usd),
              );

      expect(failure, isNull);
      expect(
        container.read(cardsControllerProvider).value!.single.limits.daily,
        Money.parse('300.00', Currency.usd),
      );
    });

    test('refresh keeps prior data on failure and returns the failure',
        () async {
      final container = makeContainer()
        ..listen(cardsControllerProvider, (_, __) {});
      await settle();
      await settle();

      when(repository.getCards)
          .thenAnswer((_) async => const Result.failure(TimeoutFailure()));
      final failure =
          await container.read(cardsControllerProvider.notifier).refresh();

      expect(failure, isA<TimeoutFailure>());
      expect(
        container.read(cardsControllerProvider).value?.single.label,
        'Everyday',
      );
    });
  });

  group('RevealedPan', () {
    test('a declined biometric prompt never calls the repository', () async {
      final biometrics = _FakeBiometrics(granted: false);
      final container = makeContainer(biometrics: biometrics);

      final failure =
          await container.read(revealedPanProvider('crd_1').notifier).reveal();

      expect(failure, isNull);
      expect(biometrics.calls, 1);
      expect(container.read(revealedPanProvider('crd_1')).value, isNull);
      verifyNever(() => repository.revealPan(any()));
    });

    test('a granted prompt fetches and exposes the PAN', () async {
      when(() => repository.revealPan('crd_1'))
          .thenAnswer((_) async => const Result.success(_pan));
      final container =
          makeContainer(biometrics: _FakeBiometrics(granted: true));

      final failure =
          await container.read(revealedPanProvider('crd_1').notifier).reveal();

      expect(failure, isNull);
      expect(
        container.read(revealedPanProvider('crd_1')).value?.grouped,
        '4242 4242 4242 4242',
      );
    });

    test('hide clears the revealed PAN', () async {
      when(() => repository.revealPan('crd_1'))
          .thenAnswer((_) async => const Result.success(_pan));
      final container =
          makeContainer(biometrics: _FakeBiometrics(granted: true));

      final notifier = container.read(revealedPanProvider('crd_1').notifier);
      await notifier.reveal();
      expect(container.read(revealedPanProvider('crd_1')).value, isNotNull);

      notifier.hide();
      expect(container.read(revealedPanProvider('crd_1')).value, isNull);
    });

    test('a fetch failure surfaces and stays hidden', () async {
      when(() => repository.revealPan('crd_1')).thenAnswer(
        (_) async => const Result.failure(ServerFailure(message: 'boom')),
      );
      final container =
          makeContainer(biometrics: _FakeBiometrics(granted: true));

      final failure =
          await container.read(revealedPanProvider('crd_1').notifier).reveal();

      expect(failure, isA<ServerFailure>());
      expect(container.read(revealedPanProvider('crd_1')).value, isNull);
    });
  });
}
