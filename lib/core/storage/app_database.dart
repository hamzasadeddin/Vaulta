import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// Cached copy of the server's account list.
///
/// Money is stored exactly as it travels on the wire: integer minor units
/// plus an ISO 4217 code — mirroring the eventual Postgres schema
/// (`bigint` + `char(3)`, §6.14 of the handoff). [balanceMinor] is an
/// `int64` column so amounts survive the web (JS number) backend intact.
class CachedAccounts extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get type => text()();
  TextColumn get iban => text()();
  TextColumn get currency => text()();
  Int64Column get balanceMinor => int64()();
  DateTimeColumn get openedAt => dateTime()();

  /// Preserves the server's list ordering across cache round trips.
  IntColumn get position => integer()();

  /// When this row was written — staleness signal for future policies.
  DateTimeColumn get fetchedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Cached balance-history points, keyed by (account, range window, day).
/// Currency is denormalized so a cached range is self-contained.
class CachedBalancePoints extends Table {
  TextColumn get accountId => text()();
  IntColumn get rangeDays => integer()();
  DateTimeColumn get date => dateTime()();
  TextColumn get currency => text()();
  Int64Column get balanceMinor => int64()();

  @override
  Set<Column<Object>> get primaryKey => {accountId, rangeDays, date};
}

/// On-device cache (not a server database). Opened lazily; a platform
/// where it cannot open (e.g. web without the sqlite wasm bundle, see
/// below) surfaces as stream/query errors that the accounts repository
/// downgrades to cache misses — the app keeps working network-only.
@DriftDatabase(tables: [CachedAccounts, CachedBalancePoints])
class AppDatabase extends _$AppDatabase {
  /// Pass an executor in tests (e.g. `NativeDatabase.memory()`).
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _open());

  @override
  int get schemaVersion => 1;

  // coverage:ignore-start
  // Platform executor selection (native vs web wasm) can't run under the
  // VM test harness; the mapping logic is covered by
  // accounts_local_data_source_test against an in-memory database.
  static QueryExecutor _open() {
    return driftDatabase(
      name: 'vaulta_cache',
      // Web needs `web/sqlite3.wasm` and `web/drift_worker.js` (see the
      // drift docs' "web" page). Without them the cache degrades to a
      // no-op and the accounts feature runs network-only — by design.
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
  }
  // coverage:ignore-end
}
