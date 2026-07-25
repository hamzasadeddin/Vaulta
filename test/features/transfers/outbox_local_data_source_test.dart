import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/iban/iban.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/core/storage/app_database.dart';
import 'package:vaulta/features/transfers/data/datasources/outbox_local_data_source.dart';
import 'package:vaulta/features/transfers/domain/entities/outbox_entry.dart';
import 'package:vaulta/features/transfers/domain/entities/transfer.dart';

/// Exercises the real Drift mapping for the outbox. Skipped wholesale if
/// sqlite3 cannot load on the runner — the same defensive stance the
/// accounts cache takes on web without the wasm bundle.
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

final _now = DateTime(2026, 7, 24, 12);

OutboxEntry _entry(
  String id, {
  TransferDestination? destination,
  OutboxStatus status = OutboxStatus.pending,
  DateTime? queuedAt,
  DateTime? nextAttemptAt,
  String? note,
  DateTime? scheduledFor,
  int attempts = 0,
  int serverErrors = 0,
  OutboxAttention? attention,
  String? reference,
}) {
  return OutboxEntry(
    id: id,
    transferId: 'trf_$id',
    idempotencyKey: 'idem_trf_$id',
    request: TransferRequest(
      sourceAccountId: 'acc_chk',
      destination: destination ?? const BeneficiaryDestination('ben_layla'),
      amount: Money.parse('250.00', Currency.usd),
      note: note,
      scheduledFor: scheduledFor,
    ),
    snapshot: OutboxSnapshot(
      destinationLabel: 'Layla Haddad',
      destinationDetail: '\u2022\u2022\u2022\u2022 4471',
      totalDebit: Money.parse('251.25', Currency.usd),
      destinationAmount: Money.parse('177.250', Currency.jod),
    ),
    queuedAt: queuedAt ?? _now,
    status: status,
    attempts: attempts,
    serverErrors: serverErrors,
    nextAttemptAt: nextAttemptAt,
    attention: attention,
    reference: reference,
  );
}

Future<void> main() async {
  final sqliteAvailable = await _sqliteAvailable();

  group(
    'DriftOutboxLocalDataSource',
    () {
      late AppDatabase db;
      late DriftOutboxLocalDataSource local;

      setUp(() {
        db = AppDatabase(NativeDatabase.memory());
        local = DriftOutboxLocalDataSource(db);
      });

      tearDown(() => db.close());

      test('round-trips an entry through SQL unchanged', () async {
        // Equality is over the whole entry, request included — the row
        // has to rebuild the instruction, not just describe it.
        final entry = _entry(
          'a',
          note: 'rent',
          nextAttemptAt: _now.add(const Duration(seconds: 30)),
          attempts: 3,
          serverErrors: 1,
        );
        await local.upsert(entry);

        final stored = await local.pending();

        expect(stored, [entry]);
      });

      test('round-trips every destination in the sealed union', () async {
        // Each variant flattens to different columns, so each needs its
        // own proof that it comes back as the same case it went in as.
        final iban = Iban.tryParse('JO82VBNK0001000000000010204573');
        expect(iban, isNotNull);

        final destinations = <TransferDestination>[
          const OwnAccountDestination('acc_sav'),
          const BeneficiaryDestination('ben_omar'),
          IbanDestination(iban: iban!, holderName: 'Omar Nassar'),
        ];

        for (final (index, destination) in destinations.indexed) {
          await local.upsert(
            _entry(
              'd$index',
              destination: destination,
              queuedAt: _now.add(Duration(seconds: index)),
            ),
          );
        }

        final stored = await local.pending();

        expect(
          stored.map((e) => e.request.destination).toList(),
          destinations,
        );
      });

      test('keeps a scheduled transfer scheduled', () async {
        final at = DateTime(2026, 8, 1, 9);
        await local.upsert(_entry('a', scheduledFor: at));

        final stored = await local.pending();

        expect(stored.single.request.scheduledFor, at);
      });

      test('pending() returns only pending rows, oldest first', () async {
        await local.upsert(
          _entry('late', queuedAt: _now.add(const Duration(minutes: 5))),
        );
        await local.upsert(_entry('early', queuedAt: _now));
        await local.upsert(_entry('gone', status: OutboxStatus.sent));
        await local.upsert(
          _entry(
            'stuck',
            status: OutboxStatus.needsAttention,
            attention: OutboxAttention.rateExpired,
          ),
        );

        final stored = await local.pending();

        expect(stored.map((e) => e.id).toList(), ['early', 'late']);
      });

      test('upsert replaces rather than duplicating', () async {
        await local.upsert(_entry('a'));
        await local.upsert(
          _entry('a').afterFailure(
            const ServerFailure(
              message: 'This quote has expired',
              statusCode: 409,
              errorCode: 'QUOTE_EXPIRED',
            ),
            now: _now,
          ),
        );

        final all = await local.watchAll().first;

        expect(all, hasLength(1));
        expect(all.single.status, OutboxStatus.needsAttention);
        expect(all.single.attention, OutboxAttention.rateExpired);
      });

      test('resetInFlight returns stranded rows to the queue', () async {
        await local.upsert(
          _entry(
            'crashed',
            status: OutboxStatus.inFlight,
            nextAttemptAt: _now.add(const Duration(minutes: 10)),
          ),
        );
        await local.upsert(
          _entry(
            'stuck',
            status: OutboxStatus.needsAttention,
            attention: OutboxAttention.exhausted,
          ),
        );

        await local.resetInFlight();
        final pending = await local.pending();

        expect(pending.map((e) => e.id).toList(), ['crashed']);
        // The backoff goes too, or a recovered entry would sit out a
        // delay that belonged to a different attempt.
        expect(pending.single.nextAttemptAt, isNull);
        expect(pending.single.isDueAt(_now), isTrue);
      });

      test('deleteSent removes only delivered entries', () async {
        await local.upsert(
          _entry('done', status: OutboxStatus.sent, reference: 'VLT-1'),
        );
        await local.upsert(_entry('waiting'));

        await local.deleteSent();
        final all = await local.watchAll().first;

        expect(all.map((e) => e.id).toList(), ['waiting']);
      });

      test('delete removes one entry by id', () async {
        await local.upsert(_entry('a'));
        await local.upsert(_entry('b', queuedAt: _now.add(_second)));

        await local.delete('a');
        final all = await local.watchAll().first;

        expect(all.map((e) => e.id).toList(), ['b']);
      });

      test('watchAll emits on every change', () async {
        final emissions = <int>[];
        final subscription =
            local.watchAll().listen((rows) => emissions.add(rows.length));
        addTearDown(subscription.cancel);

        await local.upsert(_entry('a'));
        await local.upsert(_entry('b', queuedAt: _now.add(_second)));
        await local.delete('a');
        await Future<void>.delayed(Duration.zero);

        expect(emissions.last, 1);
      });
    },
    skip: sqliteAvailable ? false : 'sqlite3 unavailable on this runner',
  );
}

const _second = Duration(seconds: 1);
