import 'package:flutter_test/flutter_test.dart';
import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/features/transfers/domain/entities/outbox_entry.dart';
import 'package:vaulta/features/transfers/domain/entities/transfer.dart';

final _now = DateTime(2026, 7, 24, 12);

OutboxEntry _entry({
  OutboxStatus status = OutboxStatus.pending,
  int attempts = 0,
  int serverErrors = 0,
  DateTime? nextAttemptAt,
}) {
  return OutboxEntry(
    id: 'obx_1',
    transferId: 'trf_1',
    idempotencyKey: 'idem_trf_1',
    request: TransferRequest(
      sourceAccountId: 'acc_chk',
      destination: const BeneficiaryDestination('ben_layla'),
      amount: Money.parse('250.00', Currency.usd),
    ),
    snapshot: OutboxSnapshot(
      destinationLabel: 'Layla Haddad',
      destinationDetail: '\u2022\u2022\u2022\u2022 4471',
      totalDebit: Money.parse('251.25', Currency.usd),
      destinationAmount: Money.parse('177.250', Currency.jod),
    ),
    queuedAt: _now,
    status: status,
    attempts: attempts,
    serverErrors: serverErrors,
    nextAttemptAt: nextAttemptAt,
  );
}

Transfer _transfer() => Transfer(
      id: 'trf_1',
      reference: 'VLT-2026-123456',
      status: TransferStatus.completed,
      sourceAccountId: 'acc_chk',
      destinationLabel: 'Layla Haddad',
      destinationDetail: '\u2022\u2022\u2022\u2022 4471',
      amount: Money.parse('250.00', Currency.usd),
      fee: Money.parse('1.25', Currency.usd),
      totalDebit: Money.parse('251.25', Currency.usd),
      destinationAmount: Money.parse('177.250', Currency.jod),
      createdAt: _now,
    );

void main() {
  group('afterFailure — transport', () {
    test('re-queues rather than escalating, and schedules a backoff', () {
      final next = _entry().afterFailure(
        const NetworkFailure(),
        now: _now,
      );

      expect(next.status, OutboxStatus.pending);
      expect(next.attempts, 1);
      expect(next.attention, isNull);
      expect(next.nextAttemptAt, _now.add(OutboxEntry.retryDelays.first));
    });

    test('a timeout is retried, not surfaced', () {
      // The ambiguous case: the request may well have landed. Retrying is
      // only safe because the idempotency key collapses a double send
      // onto one transfer — which is the entire premise of this phase.
      final next = _entry().afterFailure(
        const TimeoutFailure(),
        now: _now,
      );

      expect(next.status, OutboxStatus.pending);
    });

    test('backoff grows with attempts and then holds at the cap', () {
      const delays = OutboxEntry.retryDelays;
      for (var attempt = 0; attempt < delays.length + 3; attempt++) {
        final next = _entry(attempts: attempt).afterFailure(
          const NetworkFailure(),
          now: _now,
        );
        final expected = delays[attempt.clamp(0, delays.length - 1)];
        expect(next.nextAttemptAt, _now.add(expected));
      }
    });

    test('never exhausts — an offline week is not a failed transfer', () {
      var entry = _entry();
      for (var i = 0; i < OutboxEntry.maxServerErrors * 3; i++) {
        entry = entry.afterFailure(const NetworkFailure(), now: _now);
      }

      expect(entry.status, OutboxStatus.pending);
      expect(entry.serverErrors, 0);
    });

    test('a dead session holds the transfer instead of failing it', () {
      final next = _entry().afterFailure(
        const AuthFailure(),
        now: _now,
      );

      expect(next.status, OutboxStatus.pending);
    });
  });

  group('afterFailure — the server answered', () {
    test('an expired quote stops and asks for a new price', () {
      final next = _entry().afterFailure(
        const ServerFailure(
          message: 'This quote has expired',
          statusCode: 409,
          errorCode: 'QUOTE_EXPIRED',
        ),
        now: _now,
      );

      expect(next.status, OutboxStatus.needsAttention);
      expect(next.attention, OutboxAttention.rateExpired);
      expect(next.needsReprice, isTrue);
      // Nothing to count down to — the entry is waiting on a person.
      expect(next.nextAttemptAt, isNull);
    });

    test('a missing draft is terminal, because the key already missed', () {
      // A 404 is only reachable once the server's idempotency ledger has
      // said this key never settled. That is what makes it safe to treat
      // as "nothing was sent" rather than "we lost track of it".
      final next = _entry().afterFailure(
        const ServerFailure(message: 'Not found', statusCode: 404),
        now: _now,
      );

      expect(next.attention, OutboxAttention.draftGone);
      expect(next.needsReprice, isTrue);
    });

    test('a rejected transfer is not retried into the same refusal', () {
      final next = _entry().afterFailure(
        const ValidationFailure(
          fieldErrors: {
            'amountMinor': ['Not enough available balance'],
          },
        ),
        now: _now,
      );

      expect(next.attention, OutboxAttention.rejected);
    });

    test('server errors retry, then give up and ask', () {
      var entry = _entry();
      const failure = ServerFailure(message: 'Boom', statusCode: 500);

      for (var i = 1; i < OutboxEntry.maxServerErrors; i++) {
        entry = entry.afterFailure(failure, now: _now);
        expect(entry.status, OutboxStatus.pending, reason: 'attempt $i');
      }

      entry = entry.afterFailure(failure, now: _now);
      expect(entry.status, OutboxStatus.needsAttention);
      expect(entry.attention, OutboxAttention.exhausted);
      // The draft is still alive here, so another try is the right
      // offer — unlike every other attention reason.
      expect(entry.needsReprice, isFalse);
    });
  });

  group('scheduling', () {
    test('is not due before its next attempt time', () {
      final entry = _entry(nextAttemptAt: _now.add(const Duration(minutes: 2)));

      expect(entry.isDueAt(_now), isFalse);
      expect(entry.isDueAt(_now.add(const Duration(minutes: 2))), isTrue);
      expect(entry.isDueAt(_now.add(const Duration(hours: 1))), isTrue);
    });

    test('an entry with no schedule is due immediately', () {
      expect(_entry().isDueAt(_now), isTrue);
    });

    test('only pending entries are ever due', () {
      for (final status in OutboxStatus.values) {
        expect(
          _entry(status: status).isDueAt(_now),
          status == OutboxStatus.pending,
          reason: status.name,
        );
      }
    });

    test('a manual retry clears both the backoff and the give-up count', () {
      final stuck = _entry(
        status: OutboxStatus.needsAttention,
        serverErrors: OutboxEntry.maxServerErrors,
        nextAttemptAt: _now.add(const Duration(minutes: 10)),
      ).copyWith(attention: OutboxAttention.exhausted);

      final retried = stuck.retriedNow();

      expect(retried.status, OutboxStatus.pending);
      expect(retried.attention, isNull);
      expect(retried.serverErrors, 0);
      expect(retried.isDueAt(_now), isTrue);
    });
  });

  group('recovery', () {
    test('an entry stranded in flight returns to the queue', () {
      // A process killed mid-request. Replaying is safe; assuming it
      // landed would silently drop a transfer.
      final recovered = _entry(status: OutboxStatus.inFlight).recovered();

      expect(recovered.status, OutboxStatus.pending);
      expect(recovered.isDueAt(_now), isTrue);
    });

    test('leaves every other status alone', () {
      for (final status in OutboxStatus.values) {
        if (status == OutboxStatus.inFlight) continue;
        expect(_entry(status: status).recovered().status, status);
      }
    });
  });

  test('a settled entry keeps its reference and drops its attention', () {
    final settled = _entry(status: OutboxStatus.needsAttention)
        .copyWith(attention: OutboxAttention.exhausted)
        .settled(_transfer());

    expect(settled.status, OutboxStatus.sent);
    expect(settled.reference, 'VLT-2026-123456');
    expect(settled.attention, isNull);
  });
}
