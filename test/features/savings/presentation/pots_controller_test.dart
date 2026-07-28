import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/features/savings/domain/entities/pot.dart';
import 'package:vaulta/features/savings/presentation/providers/pots_providers.dart';

import '../support/fake_pots.dart';

void main() {
  late FakePotsRepository repo;
  late ProviderContainer container;

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  final samplePots = [
    Pot(
      id: 'pot_rainy',
      accountId: 'acc_chk',
      name: 'Rainy Day',
      balance: Money.parse('450.00', Currency.usd),
      goal: Money.parse('2000.00', Currency.usd),
    ),
  ];

  setUp(() {
    repo = FakePotsRepository(pots: samplePots);
    container = ProviderContainer(
      overrides: [potsRepositoryProvider.overrideWithValue(repo)],
    );
  });

  tearDown(() => container.dispose());

  test('starts on the skeleton, then paints the pots', () async {
    final sub = container.listen(potsControllerProvider, (_, __) {});
    expect(sub.read(), const AsyncValue<List<Pot>>.loading());

    await settle();
    await settle();
    expect(sub.read().value, samplePots);
    expect(repo.getPotsCalls, 1);
  });

  test('surfaces a load failure as AsyncError', () async {
    repo.getFailure = const NetworkFailure();
    final sub = container.listen(potsControllerProvider, (_, __) {});

    await settle();
    await settle();
    expect(sub.read(), isA<AsyncError<List<Pot>>>());
  });

  test('createPot creates then reloads so the new pot appears', () async {
    final sub = container.listen(potsControllerProvider, (_, __) {});
    await settle();
    await settle();

    final failure = await container
        .read(potsControllerProvider.notifier)
        .createPot(accountId: 'acc_chk', name: 'Japan Trip');
    expect(failure, isNull);
    expect(repo.lastCreate?.name, 'Japan Trip');

    await settle();
    await settle();
    expect(
      sub.read().value?.map((pot) => pot.name),
      contains('Japan Trip'),
    );
  });

  test('createPot returns the failure and leaves the list intact', () async {
    final sub = container.listen(potsControllerProvider, (_, __) {});
    await settle();
    await settle();

    repo.createFailure = const ValidationFailure(
      fieldErrors: {
        'name': ['Name your pot'],
      },
    );
    final failure = await container
        .read(potsControllerProvider.notifier)
        .createPot(accountId: 'acc_chk', name: '');

    expect(failure, isA<ValidationFailure>());
    await settle();
    expect(
      sub.read().value,
      samplePots,
      reason: 'unchanged after a failed create',
    );
  });
}
