import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/core/result/result.dart';
import 'package:vaulta/features/cards/domain/entities/bank_card.dart';
import 'package:vaulta/features/cards/domain/repositories/cards_repository.dart';
import 'package:vaulta/features/cards/presentation/providers/cards_providers.dart';
import 'package:vaulta/features/fraud/domain/entities/fraud_alert.dart';
import 'package:vaulta/features/fraud/presentation/providers/fraud_providers.dart';

import 'support/fake_fraud.dart';

class _MockCardsRepository extends Mock implements CardsRepository {}

BankCard _card({CardStatus status = CardStatus.frozen}) => BankCard(
      id: 'crd_chk_virt',
      accountId: 'acc_chk',
      label: 'Online shopping',
      type: CardType.virtual,
      network: CardNetwork.mastercard,
      status: status,
      panLast4: '4242',
      expiryMonth: 3,
      expiryYear: 2027,
      limits: CardLimits(
        daily: Money.parse('250.00', Currency.usd),
        monthly: Money.parse('4000.00', Currency.usd),
        spentToday: Money.zero(Currency.usd),
        spentThisMonth: Money.zero(Currency.usd),
      ),
    );

void main() {
  late FakeFraudRepository repository;
  late RecordingFraudNotifier notifier;
  late _MockCardsRepository cards;

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  setUp(() {
    repository = FakeFraudRepository();
    notifier = RecordingFraudNotifier();
    cards = _MockCardsRepository();
  });

  ProviderContainer makeContainer() {
    final container = ProviderContainer(
      overrides: [
        fraudRepositoryProvider.overrideWithValue(repository),
        fraudNotifierProvider.overrideWithValue(notifier),
        cardsRepositoryProvider.overrideWithValue(cards),
      ],
    );
    addTearDown(container.dispose);
    addTearDown(repository.dispose);
    return container;
  }

  test('a newly-arrived active alert is announced exactly once', () async {
    makeContainer().listen(fraudAlertControllerProvider, (_, __) {});
    await settle();

    repository.push(fraudAlert(id: 'a'));
    await settle();
    repository.push(fraudAlert(id: 'a')); // same id re-emitted
    await settle();

    expect(notifier.notified, ['a']);
  });

  test('a second distinct alert is announced too', () async {
    makeContainer().listen(fraudAlertControllerProvider, (_, __) {});
    await settle();

    repository
      ..push(fraudAlert(id: 'a'))
      ..push(fraudAlert(id: 'b'));
    await settle();

    expect(notifier.notified, containsAll(['a', 'b']));
  });

  test('a non-active alert is never announced', () async {
    makeContainer().listen(fraudAlertControllerProvider, (_, __) {});
    await settle();

    repository.push(fraudAlert(id: 'frozen', status: FraudAlertStatus.frozen));
    await settle();

    expect(notifier.notified, isEmpty);
  });

  test('freezeCard freezes the card and records it on the alert', () async {
    when(
      () => cards.setCardFrozen(
        cardId: any(named: 'cardId'),
        frozen: any(named: 'frozen'),
      ),
    ).thenAnswer((_) async => Result.success(_card()));

    final container = makeContainer()
      ..listen(fraudAlertControllerProvider, (_, __) {});
    await settle();
    repository.push(fraudAlert(id: 'a'));
    await settle();

    final failure = await container
        .read(fraudAlertControllerProvider.notifier)
        .freezeCard(fraudAlert(id: 'a'));

    expect(failure, isNull);
    verify(
      () => cards.setCardFrozen(cardId: 'crd_chk_virt', frozen: true),
    ).called(1);
    expect(repository.markFrozenCalls, 1);
    expect(repository.alerts.single.status, FraudAlertStatus.frozen);
  });

  test('a failed freeze returns the failure and does not mark it frozen',
      () async {
    when(
      () => cards.setCardFrozen(
        cardId: any(named: 'cardId'),
        frozen: any(named: 'frozen'),
      ),
    ).thenAnswer((_) async => const Result.failure(NetworkFailure()));

    final container = makeContainer()
      ..listen(fraudAlertControllerProvider, (_, __) {});
    await settle();
    repository.push(fraudAlert(id: 'a'));
    await settle();

    final failure = await container
        .read(fraudAlertControllerProvider.notifier)
        .freezeCard(fraudAlert(id: 'a'));

    expect(failure, isA<NetworkFailure>());
    expect(repository.markFrozenCalls, 0);
    expect(repository.alerts.single.status, FraudAlertStatus.active);
  });

  test('dismiss drops the alert', () async {
    final container = makeContainer()
      ..listen(fraudAlertControllerProvider, (_, __) {});
    await settle();
    repository.push(fraudAlert(id: 'a'));
    await settle();

    await container.read(fraudAlertControllerProvider.notifier).dismiss('a');

    expect(repository.dismissCalls, 1);
    expect(repository.alerts, isEmpty);
  });
}
