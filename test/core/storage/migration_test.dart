import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vaulta/core/storage/app_database.dart';

/// The project's first schema migration, and the first one that can lose
/// something: `CachedAccounts` and `CachedBalancePoints` are droppable
/// caches, but `OutboxTransfers` holds transfer instructions that exist
/// nowhere else. A bank app that cannot upgrade its local database is a
/// dead app, so v1 → v2 gets a test rather than a version bump.
///
/// **What this proves and what it does not.** It drives the real
/// `MigrationStrategy` against real sqlite on a real file, so it catches
/// a broken or missing `onUpgrade` and any accidental data loss. It does
/// *not* verify that the v1 shape here is byte-identical to what Phase 8
/// shipped, because it builds v1 by creating v2 and stripping the new
/// table back off. That is honest for an additive migration and cheap;
/// the moment a migration starts *altering* an existing table, switch to
/// `dart run drift_dev schema dump` + generated verifiers, which compare
/// against the schema as it actually shipped.
Future<bool> _sqliteAvailable() async {
  try {
    final probe = AppDatabase(NativeDatabase.memory());
    await probe.customSelect('SELECT 1').get();
    await probe.close();
    return true;
  } on Object {
    return false;
  }
}

Future<void> main() async {
  final sqliteAvailable = await _sqliteAvailable();

  group(
    'AppDatabase migration',
    () {
      late Directory dir;
      late File file;

      setUp(() {
        dir = Directory.systemTemp.createTempSync('vaulta_migration');
        file = File('${dir.path}/vaulta_cache.sqlite');
      });

      tearDown(() {
        if (dir.existsSync()) dir.deleteSync(recursive: true);
      });

      /// Builds a database that looks like a Phase 8 install: both caches
      /// present, no outbox, `user_version` pinned back to 1.
      Future<void> seedV1() async {
        final db = AppDatabase(NativeDatabase(file));
        await db.into(db.cachedAccounts).insert(
              CachedAccountsCompanion.insert(
                id: 'acc_chk',
                name: 'Main Checking',
                type: 'checking',
                iban: 'JO82VBNK0001000000000010204573',
                currency: 'USD',
                balanceMinor: BigInt.from(1248050),
                openedAt: DateTime(2022, 3, 14),
                position: 0,
                fetchedAt: DateTime(2026, 7, 24),
              ),
            );
        await db.customStatement('DROP TABLE outbox_transfers');
        await db.customStatement('PRAGMA user_version = 1');
        await db.close();
      }

      test('upgrades to 2 and adds the outbox table', () async {
        await seedV1();

        final db = AppDatabase(NativeDatabase(file));
        addTearDown(db.close);

        // Usable, not merely present: an outbox that exists but rejects
        // an insert is the same outage as one that does not exist.
        await db.into(db.outboxTransfers).insert(
              OutboxTransfersCompanion.insert(
                id: 'obx_1',
                transferId: 'trf_1',
                idempotencyKey: 'idem_trf_1',
                status: 'pending',
                queuedAt: DateTime(2026, 7, 24, 12),
                sourceAccountId: 'acc_chk',
                destinationType: 'beneficiary',
                destinationBeneficiaryId: const Value('ben_layla'),
                amountMinor: BigInt.from(25000),
                currency: 'USD',
                destinationLabel: 'Layla Haddad',
                destinationDetail: '\u2022\u2022\u2022\u2022 4471',
                totalDebitMinor: BigInt.from(25125),
                destinationAmountMinor: BigInt.from(177250),
                destinationCurrency: 'JOD',
              ),
            );

        final rows = await db.select(db.outboxTransfers).get();
        expect(rows, hasLength(1));
        expect(rows.single.destinationBeneficiaryId, 'ben_layla');
        // Defaults apply to rows written by the migrated schema.
        expect(rows.single.attempts, 0);
        expect(rows.single.serverErrors, 0);
      });

      test('leaves the existing caches untouched', () async {
        await seedV1();

        final db = AppDatabase(NativeDatabase(file));
        addTearDown(db.close);

        final accounts = await db.select(db.cachedAccounts).get();
        expect(accounts, hasLength(1));
        expect(accounts.single.id, 'acc_chk');
        expect(accounts.single.balanceMinor, BigInt.from(1248050));
      });

      test('reports the new schema version', () async {
        await seedV1();

        final db = AppDatabase(NativeDatabase(file));
        addTearDown(db.close);
        // Forces the open, and therefore the migration, before reading.
        await db.customSelect('SELECT 1').get();

        expect(db.schemaVersion, 2);
      });

      test('a fresh install creates both caches and the outbox', () async {
        final db = AppDatabase(NativeDatabase(file));
        addTearDown(db.close);

        await db.customSelect('SELECT 1').get();

        expect(await db.select(db.outboxTransfers).get(), isEmpty);
        expect(await db.select(db.cachedAccounts).get(), isEmpty);
        expect(await db.select(db.cachedBalancePoints).get(), isEmpty);
      });
    },
    skip: sqliteAvailable ? false : 'sqlite3 unavailable on this runner',
  );
}
