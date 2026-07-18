import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/core/result/result.dart';
import 'package:vaulta/features/accounts/domain/entities/account.dart';
import 'package:vaulta/features/accounts/domain/repositories/accounts_repository.dart';
import 'package:vaulta/features/accounts/presentation/providers/accounts_providers.dart';

class _MockAccountsRepository extends Mock implements AccountsRepository {}

final _cached = [
  Account(
    id: 'acc_chk',
    name: 'Main Checking',
    type: AccountType.checking,
    iban: 'JO82VBNK0001000000000010204573',
    balance: Money.parse('12000.00', Currency.usd),
    openedAt: DateTime(2022, 3, 14),
  ),
];

final _fresh = [
  Account(
    id: 'acc_chk',
    name: 'Main Checking',
    type: AccountType.checking,
    iban: 'JO82VBNK0001000000000010204573',
    balance: Money.parse('12480.50', Currency.usd),
    openedAt: DateTime(2022, 3, 14),
  ),
];

void main() {
  late _MockAccountsRepository repository;
  late StreamController<Result<List<Account>, Failure>> cache;
  late ProviderContainer container;

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  setUp(() {
    repository = _MockAccountsRepository();
    cache = StreamController<Result<List<Account>, Failure>>.broadcast();
    when(repository.watchAccounts).thenAnswer((_) => cache.stream);
    container = ProviderContainer(
      overrides: [accountsRepositoryProvider.overrideWithValue(repository)],
    );
  });

  tearDown(() async {
    container.dispose();
    await cache.close();
  });

  test('loads via refresh when the cache stays silent', () async {
    when(repository.refreshAccounts)
        .thenAnswer((_) async => Result.success(_fresh));

    final sub = container.listen(accountsControllerProvider, (_, __) {});
    expect(sub.read(), const AsyncValue<List<Account>>.loading());

    await settle();
    await settle();
    expect(sub.read().value, _fresh);
  });

  test('paints from the cache before the refresh lands', () async {
    final pending = Completer<Result<List<Account>, Failure>>();
    when(repository.refreshAccounts).thenAnswer((_) => pending.future);

    final sub = container.listen(accountsControllerProvider, (_, __) {});
    await settle();

    cache.add(Result.success(_cached));
    await settle();
    expect(sub.read().value, _cached, reason: 'cache-first paint');

    pending.complete(Result.success(_fresh));
    await settle();
    await settle();
    expect(sub.read().value, _fresh, reason: 'refresh supersedes cache');
  });

  test('an empty cold-cache emission does not end the skeleton', () async {
    final pending = Completer<Result<List<Account>, Failure>>();
    when(repository.refreshAccounts).thenAnswer((_) => pending.future);

    final sub = container.listen(accountsControllerProvider, (_, __) {});
    await settle();

    cache.add(const Result.success([]));
    await settle();
    expect(sub.read().isLoading, isTrue);

    pending.complete(Result.success(_fresh));
    await settle();
    await settle();
    expect(sub.read().value, _fresh);
  });

  test('a cache failure alone is not terminal', () async {
    when(repository.refreshAccounts)
        .thenAnswer((_) async => Result.success(_fresh));

    final sub = container.listen(accountsControllerProvider, (_, __) {});
    cache.add(const Result.failure(CacheFailure()));
    await settle();
    await settle();

    expect(sub.read().value, _fresh);
  });

  test('refresh failure with nothing on screen lands AsyncError', () async {
    when(repository.refreshAccounts)
        .thenAnswer((_) async => const Result.failure(NetworkFailure()));

    final sub = container.listen(accountsControllerProvider, (_, __) {});
    await settle();
    await settle();

    expect(sub.read(), isA<AsyncError<List<Account>>>());
    expect(sub.read().error, isA<NetworkFailure>());
  });

  test('refresh failure keeps visible data and hands back the failure',
      () async {
    var calls = 0;
    when(repository.refreshAccounts).thenAnswer((_) async {
      calls++;
      return calls == 1
          ? Result.success(_fresh)
          : const Result.failure(TimeoutFailure());
    });

    final sub = container.listen(accountsControllerProvider, (_, __) {});
    await settle();
    await settle();
    expect(sub.read().value, _fresh);

    final failure = await container
        .read(accountsControllerProvider.notifier)
        .refresh();

    expect(failure, isA<TimeoutFailure>());
    expect(sub.read().value, _fresh, reason: 'data survives the error');
  });

  test('accountById resolves from the loaded list', () async {
    when(repository.refreshAccounts)
        .thenAnswer((_) async => Result.success(_fresh));

    final sub = container.listen(accountsControllerProvider, (_, __) {});
    await settle();
    await settle();
    expect(sub.read().hasValue, isTrue);

    expect(
      container.read(accountByIdProvider('acc_chk')),
      _fresh.single,
    );
    expect(container.read(accountByIdProvider('acc_missing')), isNull);
  });

  test('paneAccountId starts empty and remembers the selection', () {
    expect(container.read(paneAccountIdProvider), isNull);
    container.read(paneAccountIdProvider.notifier).select('acc_chk');
    expect(container.read(paneAccountIdProvider), 'acc_chk');
  });
}
