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

/// Transfer confirms the user authorised that have not been delivered.
///
/// Unlike the two tables above this is **not a cache**. Those mirror
/// server state and can be dropped at will; a row here is an instruction
/// that exists nowhere else yet, so losing one loses a transfer the user
/// believes is on its way. That is why the outbox is durable rather than
/// in-memory, and why the migration that introduces it has a test.
///
/// The row carries three groups of columns, and none of them is
/// redundant:
///
/// - `transferId` + `idempotencyKey` replay the original confirm.
/// - the request columns (`sourceAccountId` → `scheduledFor`) rebuild a
///   `TransferRequest` so a dead draft can be re-priced offline.
/// - the snapshot columns render the queue with no server reachable.
///
/// Money keeps the wire convention: integer minor units plus a code.
class OutboxTransfers extends Table {
  /// Local id — not the transfer id. An entry exists before the server
  /// has agreed to anything and outlives being re-priced.
  TextColumn get id => text()();

  TextColumn get transferId => text()();
  TextColumn get idempotencyKey => text()();

  /// `OutboxStatus.name`. Stored as text rather than an index so a
  /// reordered enum cannot silently re-label existing rows.
  TextColumn get status => text()();

  /// `OutboxAttention.name`, null unless the status needs a person.
  TextColumn get attention => text().nullable()();

  IntColumn get attempts => integer().withDefault(const Constant(0))();
  IntColumn get serverErrors => integer().withDefault(const Constant(0))();

  DateTimeColumn get queuedAt => dateTime()();
  DateTimeColumn get nextAttemptAt => dateTime().nullable()();

  /// Set once delivered, for the "this went through" notice.
  TextColumn get reference => text().nullable()();

  // --- the original request, for re-pricing ---
  TextColumn get sourceAccountId => text()();

  /// `own` | `beneficiary` | `iban`, mirroring the wire's destination
  /// discriminator. The sealed union is reassembled in the data source.
  TextColumn get destinationType => text()();
  TextColumn get destinationAccountId => text().nullable()();
  TextColumn get destinationBeneficiaryId => text().nullable()();
  TextColumn get destinationIban => text().nullable()();
  TextColumn get destinationHolderName => text().nullable()();
  Int64Column get amountMinor => int64()();
  TextColumn get currency => text()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get scheduledFor => dateTime().nullable()();

  // --- display snapshot ---
  TextColumn get destinationLabel => text()();
  TextColumn get destinationDetail => text()();
  Int64Column get totalDebitMinor => int64()();
  Int64Column get destinationAmountMinor => int64()();
  TextColumn get destinationCurrency => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// On-device storage. Two caches (droppable) and one outbox (not).
///
/// Opened lazily; a platform where it cannot open (e.g. web without the
/// sqlite wasm bundle, see below) surfaces as stream/query errors that
/// the repositories downgrade — accounts to cache misses, the outbox to
/// "the queue is unavailable", which is why a confirm that cannot be
/// queued still reports its original network failure to the user.
@DriftDatabase(
  tables: [CachedAccounts, CachedBalancePoints, OutboxTransfers],
)
class AppDatabase extends _$AppDatabase {
  /// Pass an executor in tests (e.g. `NativeDatabase.memory()`).
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _open());

  @override
  int get schemaVersion => 2;

  /// v1 → v2 adds [OutboxTransfers] and touches nothing else.
  ///
  /// The project's first migration. Additive by design: an install
  /// upgrading from Phase 8 keeps its cached accounts and history, and
  /// the new table simply appears empty. `onUpgrade` is deliberately
  /// written as a version *range* check rather than an `if (from == 1)`
  /// so a device that skipped a release still lands correctly.
  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(outboxTransfers);
          }
        },
      );

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
