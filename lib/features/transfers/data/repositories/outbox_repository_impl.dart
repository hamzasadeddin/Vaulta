import 'dart:async';

import 'package:uuid/uuid.dart';
import 'package:vaulta/core/error/exception_mapper.dart';
import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/result/result.dart';
import 'package:vaulta/features/transfers/data/datasources/outbox_local_data_source.dart';
import 'package:vaulta/features/transfers/domain/entities/outbox_entry.dart';
import 'package:vaulta/features/transfers/domain/entities/transfer.dart';
import 'package:vaulta/features/transfers/domain/repositories/outbox_repository.dart';

/// Persistence for the transfer outbox. Deliberately thin — no retry
/// policy, no clock-driven decisions beyond stamping and filtering, so
/// the interesting behaviour stays in `DrainOutbox` where it is testable
/// without sqlite.
///
/// Unlike `AccountsRepositoryImpl` this does **not** swallow storage
/// errors. A cache write that fails is an optimization lost; an outbox
/// write that fails means a transfer the user was told is queued is not
/// queued, and the caller has to know that so it can report the original
/// network failure instead of a false reassurance.
class OutboxRepositoryImpl implements OutboxRepository {
  OutboxRepositoryImpl({
    required OutboxLocalDataSource local,
    DateTime Function()? clock,
    Uuid uuid = const Uuid(),
  })  : _local = local,
        _clock = clock ?? DateTime.now,
        _uuid = uuid;

  final OutboxLocalDataSource _local;
  final DateTime Function() _clock;
  final Uuid _uuid;

  @override
  Stream<Result<List<OutboxEntry>, Failure>> watch() {
    // As in `AccountsRepositoryImpl.watchAccounts`: a try/catch around
    // `yield*` does not see errors emitted *by* the inner stream, so the
    // error-to-value mapping has to live in a transformer.
    return _local.watchAll().transform(
          StreamTransformer<List<OutboxEntry>,
              Result<List<OutboxEntry>, Failure>>.fromHandlers(
            handleData: (entries, sink) => sink.add(Result.success(entries)),
            handleError: (error, stackTrace, sink) => sink.add(
              Result.failure(
                CacheFailure(
                  message: 'Could not read the transfer outbox',
                  cause: error,
                  stackTrace: stackTrace,
                ),
              ),
            ),
          ),
        );
  }

  @override
  Future<Result<OutboxEntry, Failure>> enqueue({
    required TransferQuote quote,
    required TransferRequest request,
  }) {
    return runCatching(() async {
      final entry = OutboxEntry(
        id: _uuid.v4(),
        transferId: quote.id,
        idempotencyKey: quote.idempotencyKey,
        request: request,
        snapshot: OutboxSnapshot(
          destinationLabel: quote.destinationLabel,
          destinationDetail: quote.destinationDetail,
          totalDebit: quote.totalDebit,
          destinationAmount: quote.destinationAmount,
        ),
        queuedAt: _clock(),
      );
      await _local.upsert(entry);
      return entry;
    });
  }

  @override
  Future<Result<List<OutboxEntry>, Failure>> due() {
    return runCatching(() async {
      final now = _clock();
      final pending = await _local.pending();
      return [
        for (final entry in pending)
          if (entry.isDueAt(now)) entry,
      ];
    });
  }

  @override
  Future<Result<void, Failure>> save(OutboxEntry entry) =>
      runCatching<void>(() => _local.upsert(entry));

  @override
  Future<Result<void, Failure>> discard(String id) =>
      runCatching<void>(() => _local.delete(id));

  @override
  Future<Result<void, Failure>> recoverInFlight() =>
      runCatching<void>(_local.resetInFlight);

  @override
  Future<Result<void, Failure>> clearSent() =>
      runCatching<void>(_local.deleteSent);
}
