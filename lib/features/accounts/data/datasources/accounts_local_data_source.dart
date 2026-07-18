import 'package:drift/drift.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/core/storage/app_database.dart';
import 'package:vaulta/features/accounts/domain/entities/account.dart';
import 'package:vaulta/features/accounts/domain/entities/balance_point.dart';
import 'package:vaulta/features/accounts/domain/entities/history_range.dart';

/// Seam over the Drift cache so the repository is testable without a real
/// database. The Drift implementation maps rows ↔ domain at this boundary;
/// SQL types never leak upward. Methods throw on storage failure — the
/// repository downgrades those to cache misses.
abstract interface class AccountsLocalDataSource {
  Stream<List<Account>> watchAccounts();

  Future<void> replaceAccounts(
    List<Account> accounts, {
    required DateTime fetchedAt,
  });

  Future<List<BalancePoint>> getHistory(String accountId, HistoryRange range);

  Future<void> replaceHistory(
    String accountId,
    HistoryRange range,
    List<BalancePoint> points,
  );
}

class DriftAccountsLocalDataSource implements AccountsLocalDataSource {
  const DriftAccountsLocalDataSource(this._db);

  final AppDatabase _db;

  @override
  Stream<List<Account>> watchAccounts() {
    final query = _db.select(_db.cachedAccounts)
      ..orderBy([(t) => OrderingTerm.asc(t.position)]);
    return query
        .watch()
        .map((rows) => [for (final row in rows) _accountFromRow(row)]);
  }

  @override
  Future<void> replaceAccounts(
    List<Account> accounts, {
    required DateTime fetchedAt,
  }) {
    // Delete-then-insert inside one transaction: the cache mirrors server
    // truth exactly, including accounts that disappeared.
    return _db.transaction(() async {
      await _db.delete(_db.cachedAccounts).go();
      await _db.batch((batch) {
        batch.insertAll(_db.cachedAccounts, [
          for (final (index, account) in accounts.indexed)
            CachedAccountsCompanion.insert(
              id: account.id,
              name: account.name,
              type: account.type.name,
              iban: account.iban,
              currency: account.currency.code,
              balanceMinor: account.balance.minorUnits,
              openedAt: account.openedAt,
              position: index,
              fetchedAt: fetchedAt,
            ),
        ]);
      });
    });
  }

  @override
  Future<List<BalancePoint>> getHistory(
    String accountId,
    HistoryRange range,
  ) async {
    final query = _db.select(_db.cachedBalancePoints)
      ..where(
        (t) => t.accountId.equals(accountId) & t.rangeDays.equals(range.days),
      )
      ..orderBy([(t) => OrderingTerm.asc(t.date)]);
    final rows = await query.get();
    return [
      for (final row in rows)
        BalancePoint(
          date: row.date,
          balance: Money.fromMinorUnits(
            row.balanceMinor,
            // Written by this app, so the code is one we support.
            Currency.fromCode(row.currency),
          ),
        ),
    ];
  }

  @override
  Future<void> replaceHistory(
    String accountId,
    HistoryRange range,
    List<BalancePoint> points,
  ) {
    return _db.transaction(() async {
      await (_db.delete(_db.cachedBalancePoints)
            ..where(
              (t) =>
                  t.accountId.equals(accountId) &
                  t.rangeDays.equals(range.days),
            ))
          .go();
      await _db.batch((batch) {
        batch.insertAll(_db.cachedBalancePoints, [
          for (final point in points)
            CachedBalancePointsCompanion.insert(
              accountId: accountId,
              rangeDays: range.days,
              date: point.date,
              currency: point.balance.currency.code,
              balanceMinor: point.balance.minorUnits,
            ),
        ]);
      });
    });
  }

  Account _accountFromRow(CachedAccount row) {
    return Account(
      id: row.id,
      name: row.name,
      type: AccountType.values.asNameMap()[row.type] ?? AccountType.checking,
      iban: row.iban,
      balance: Money.fromMinorUnits(
        row.balanceMinor,
        Currency.fromCode(row.currency),
      ),
      openedAt: row.openedAt,
    );
  }
}
