import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/core/result/result.dart';
import 'package:vaulta/core/usecase/use_case.dart';
import 'package:vaulta/features/transfers/domain/entities/outbox_entry.dart';
import 'package:vaulta/features/transfers/domain/entities/transfer.dart';
import 'package:vaulta/features/transfers/domain/repositories/outbox_repository.dart';
import 'package:vaulta/features/transfers/domain/repositories/transfers_repository.dart';
import 'package:vaulta/features/transfers/domain/usecases/outbox_usecases.dart';

class _MockOutbox extends Mock implements OutboxRepository {}

class _MockTransfers extends Mock implements TransfersRepository {}

class _FakeEntry extends Fake implements OutboxEntry {}

final _now = DateTime(2026, 7, 24, 12);

OutboxEntry _entry(String id, {DateTime? queuedAt}) => OutboxEntry(
      id: id,
      transferId: 'trf_$id',
      idempotencyKey: 'idem_trf_$id',
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
      queuedAt: queuedAt ?? _now,
    );

Transfer _transfer(String id) => Transfer(
      id: 'trf_$id',
      reference: 'VLT-2026-$id',
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
  late _MockOutbox outbox;
  late _MockTransfers transfers;
  late DrainOutbox drain;

  /// Every entry the drain persisted, in order.
  List<OutboxEntry> saved() {
    final captured = verify(() => outbox.save(captureAny())).captured;
    return captured.cast<OutboxEntry>();
  }

  setUpAll(() => registerFallbackValue(_FakeEntry()));

  setUp(() {
    outbox = _MockOutbox();
    transfers = _MockTransfers();
    drain = DrainOutbox(
      outbox: outbox,
      transfers: transfers,
      clock: () => _now,
    );
    when(() => outbox.save(any()))
        .thenAnswer((_) async => const Result<void, Failure>.success(null));
  });

  void givenDue(List<OutboxEntry> entries) {
    when(outbox.due).thenAnswer((_) async => Result.success(entries));
  }

  void givenConfirm(Result<Transfer, Failure> result) {
    when(
      () => transfers.confirmTransfer(
        transferId: any(named: 'transferId'),
        idempotencyKey: any(named: 'idempotencyKey'),
      ),
    ).thenAnswer((_) async => result);
  }

  test('an empty queue does no work', () async {
    givenDue([]);

    final result = await drain.call(const NoParams());

    expect(result.valueOrNull, const OutboxDrainReport());
    expect(result.valueOrNull?.isEmpty, isTrue);
    verifyNever(
      () => transfers.confirmTransfer(
        transferId: any(named: 'transferId'),
        idempotencyKey: any(named: 'idempotencyKey'),
      ),
    );
  });

  test('replays the quote\u2019s own idempotency key, not a fresh one',
      () async {
    // The whole safety property. A key minted at send time would make
    // every retry a new transfer.
    givenDue([_entry('a')]);
    givenConfirm(Result.success(_transfer('a')));

    await drain.call(const NoParams());

    verify(
      () => transfers.confirmTransfer(
        transferId: 'trf_a',
        idempotencyKey: 'idem_trf_a',
      ),
    ).called(1);
  });

  test('marks an entry in flight before the request goes out', () async {
    // Persisted first so a kill mid-request is visible on next launch
    // rather than looking like an entry that was never attempted.
    givenDue([_entry('a')]);
    givenConfirm(Result.success(_transfer('a')));

    await drain.call(const NoParams());

    final writes = saved();
    expect(writes.first.status, OutboxStatus.inFlight);
    expect(writes.last.status, OutboxStatus.sent);
    expect(writes.last.reference, 'VLT-2026-a');
  });

  test('sends in queue order, one at a time', () async {
    // Two debits from one account can each fit the balance alone and not
    // together, so concurrency would make which one bounces a race.
    givenDue([
      _entry('a', queuedAt: _now),
      _entry('b', queuedAt: _now.add(const Duration(seconds: 1))),
    ]);
    givenConfirm(Result.success(_transfer('a')));

    final result = await drain.call(const NoParams());

    expect(result.valueOrNull?.attempted, 2);
    expect(result.valueOrNull?.sent, 2);
    final order = saved().map((e) => e.id).toList();
    expect(order, ['a', 'a', 'b', 'b']);
  });

  test('a settled confirm is recorded even long after its lock died', () async {
    // Handoff 8 §37 in executable form, from the outbox side: the client
    // never pre-judges expiry locally. It asks, and a server that
    // answers from its idempotency ledger is answering about work that
    // already happened — expiry may refuse work that has not happened,
    // it may never retract work that has.
    givenDue([_entry('a', queuedAt: _now.subtract(const Duration(days: 1)))]);
    givenConfirm(Result.success(_transfer('a')));

    await drain.call(const NoParams());

    expect(saved().last.status, OutboxStatus.sent);
  });

  test('a transport failure stays queued with a backoff', () async {
    givenDue([_entry('a')]);
    givenConfirm(const Result.failure(NetworkFailure()));

    final result = await drain.call(const NoParams());

    final last = saved().last;
    expect(last.status, OutboxStatus.pending);
    expect(last.nextAttemptAt, _now.add(OutboxEntry.retryDelays.first));
    expect(result.valueOrNull?.retrying, 1);
    expect(result.valueOrNull?.sent, 0);
  });

  test('an expired quote stops the entry and asks for a decision', () async {
    givenDue([_entry('a')]);
    givenConfirm(
      const Result.failure(
        ServerFailure(
          message: 'This quote has expired',
          statusCode: 409,
          errorCode: 'QUOTE_EXPIRED',
        ),
      ),
    );

    final result = await drain.call(const NoParams());

    final last = saved().last;
    expect(last.status, OutboxStatus.needsAttention);
    expect(last.attention, OutboxAttention.rateExpired);
    expect(result.valueOrNull?.needsAttention, 1);
  });

  test('an unreadable queue fails the drain instead of pretending', () async {
    when(outbox.due).thenAnswer(
      (_) async => const Result.failure(
        CacheFailure(message: 'Could not read the transfer outbox'),
      ),
    );

    final result = await drain.call(const NoParams());

    expect(result.isFailure, isTrue);
    expect(result.failureOrNull, isA<CacheFailure>());
  });

  test('a manual retry clears the backoff so the next drain picks it up',
      () async {
    final stuck = _entry('a').copyWith(
      status: OutboxStatus.needsAttention,
      attention: OutboxAttention.exhausted,
      nextAttemptAt: _now.add(const Duration(minutes: 10)),
    );

    await RetryOutboxEntry(outbox).call(stuck);

    final written = saved().single;
    expect(written.status, OutboxStatus.pending);
    expect(written.isDueAt(_now), isTrue);
  });
}
