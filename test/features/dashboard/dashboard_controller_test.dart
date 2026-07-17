import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/core/result/result.dart';
import 'package:vaulta/features/dashboard/domain/entities/account_summary.dart';
import 'package:vaulta/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:vaulta/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:vaulta/features/dashboard/presentation/providers/dashboard_providers.dart';

class _MockDashboardRepository extends Mock implements DashboardRepository {}

final _summary = DashboardSummary(
  accounts: [
    AccountSummary(
      id: 'acc_1',
      name: 'Main Checking',
      balance: Money.parse('12480.50', Currency.usd),
    ),
  ],
  recentTransactions: const [],
);

void main() {
  late _MockDashboardRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = _MockDashboardRepository();
    container = ProviderContainer(
      overrides: [
        dashboardRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
  });

  // The controller loads via a microtask; one macrotask hop settles it.
  Future<void> settle() => Future<void>.delayed(Duration.zero);

  // The controller is autoDispose: hold a subscription for the test's
  // lifetime or it dies between awaits.
  ProviderSubscription<AsyncValue<DashboardSummary>> listen() {
    final sub = container.listen(dashboardControllerProvider, (_, __) {});
    addTearDown(sub.close);
    return sub;
  }

  group('DashboardController', () {
    test('starts loading, then exposes the summary', () async {
      when(repository.getSummary)
          .thenAnswer((_) async => Result.success(_summary));

      final sub = listen();
      expect(sub.read(), isA<AsyncLoading<DashboardSummary>>());
      await settle();

      expect(sub.read().requireValue, same(_summary));
    });

    test('exposes the Failure when the initial load fails', () async {
      when(repository.getSummary).thenAnswer(
        (_) async => const Result.failure(NetworkFailure()),
      );

      final sub = listen();
      await settle();

      final state = sub.read();
      expect(state, isA<AsyncError<DashboardSummary>>());
      expect(
        (state as AsyncError<DashboardSummary>).error,
        isA<NetworkFailure>(),
      );
    });

    test('refresh keeps existing data and returns the failure', () async {
      var calls = 0;
      when(repository.getSummary).thenAnswer((_) async {
        calls++;
        return calls == 1
            ? Result.success(_summary)
            : const Result.failure(TimeoutFailure());
      });

      final sub = listen();
      await settle();
      expect(sub.read().requireValue, same(_summary));

      final failure =
          await container.read(dashboardControllerProvider.notifier).refresh();

      expect(failure, isA<TimeoutFailure>());
      expect(sub.read().requireValue, same(_summary));
    });

    test('refresh returns null and swaps data on success', () async {
      when(repository.getSummary)
          .thenAnswer((_) async => Result.success(_summary));

      final sub = listen();
      await settle();

      final failure =
          await container.read(dashboardControllerProvider.notifier).refresh();

      expect(failure, isNull);
      verify(repository.getSummary).called(2);
      expect(sub.read().requireValue, same(_summary));
    });
  });

  group('SelectedAccountId', () {
    test('defaults to null and updates on select', () {
      final sub = container.listen(selectedAccountIdProvider, (_, __) {});
      addTearDown(sub.close);

      expect(sub.read(), isNull);
      container.read(selectedAccountIdProvider.notifier).select('acc_2');
      expect(sub.read(), 'acc_2');
    });
  });
}
