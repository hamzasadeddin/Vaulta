import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/core/storage/app_database.dart';
import 'package:vaulta/features/accounts/data/datasources/accounts_local_data_source.dart';
import 'package:vaulta/features/accounts/domain/entities/account.dart';
import 'package:vaulta/features/accounts/domain/entities/balance_point.dart';
import 'package:vaulta/features/accounts/domain/entities/history_range.dart';

/// Exercises the real Drift mapping (row ↔ domain, ordering, replace
/// semantics) against an in-memory sqlite. If the sqlite3 native library
/// can't load on this runner, the whole group is skipped rather than failing
/// — the same defensive stance the cache takes on web without the wasm
/// bundle. On a runner with sqlite3 present (Linux CI, most dev machines)
/// these run and cover the data source.
Future<bool> _sqliteAvailable() async {
  try {
    // Construction may lazy-open, so force a real query to confirm the
    // native library actually loads on this runner.
    final probe = AppDatabase(NativeDatabase.memory());
    await probe.customSelect('SELECT 1').get();
    await probe.close();
    return true;
  } on Object {
    return false;
  }
}

Account _account(String id, int position, {int balanceMinor = 100000}) {
  return Account(
    id: id,
    name: 'Account $position',
    type: position.isEven ? AccountType.checking : AccountType.savings,
    iban: 'JO00VBNK000000000000000000$position',
    balance: Money.fromMinorUnits(BigInt.from(balanceMinor), Currency.usd),
    openedAt: DateTime(2022, 3, 14),
  );
}

Future<void> main() async {
  final sqliteAvailable = await _sqliteAvailable();

  group('DriftAccountsLocalDataSource', () {
    late AppDatabase db;
    late DriftAccountsLocalDataSource local;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      local = DriftAccountsLocalDataSource(db);
    });

    tearDown(() => db.close());

    test('replaceAccounts then watch emits them in stored order', () async {
      final accounts = [
        _account('acc_b', 0),
        _account('acc_a', 1),
        _account('acc_c', 2),
      ];
      await local.replaceAccounts(accounts, fetchedAt: DateTime(2026, 7, 18));

      final first = await local.watchAccounts().first;
      expect(first.map((a) => a.id), ['acc_b', 'acc_a', 'acc_c']);
      expect(first.first.balance, Money.parse('1000.00', Currency.usd));
    });

    test('replaceAccounts is a full mirror — removals disappear', () async {
      await local.replaceAccounts(
        [_account('acc_a', 0), _account('acc_b', 1)],
        fetchedAt: DateTime(2026, 7, 18),
      );
      await local.replaceAccounts(
        [_account('acc_a', 0)],
        fetchedAt: DateTime(2026, 7, 19),
      );

      final rows = await local.watchAccounts().first;
      expect(rows.map((a) => a.id), ['acc_a']);
    });

    test('history round-trips per (account, range)', () async {
      final points = [
        BalancePoint(
          date: DateTime(2026, 7),
          balance: Money.parse('100.00', Currency.usd),
        ),
        BalancePoint(
          date: DateTime(2026, 7, 2),
          balance: Money.parse('120.00', Currency.usd),
        ),
      ];
      await local.replaceHistory('acc_a', HistoryRange.month, points);

      final read = await local.getHistory('acc_a', HistoryRange.month);
      expect(read, points);
      // A different range is a different cache slot.
      final other = await local.getHistory('acc_a', HistoryRange.year);
      expect(other, isEmpty);
    });
  }, skip: sqliteAvailable ? false : 'sqlite3 native library not available',);
}
