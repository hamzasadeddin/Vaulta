import 'package:drift/drift.dart';
import 'package:vaulta/core/iban/iban.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/core/storage/app_database.dart';
import 'package:vaulta/features/transfers/domain/entities/outbox_entry.dart';
import 'package:vaulta/features/transfers/domain/entities/transfer.dart';

/// The destination union, flattened for SQL and back.
typedef _DestinationColumns = ({
  String type,
  String? accountId,
  String? beneficiaryId,
  String? iban,
  String? holderName,
});

/// Seam over the outbox table so the repository is testable without a
/// real database. Rows map to domain here; SQL types never leak upward.
/// Methods throw on storage failure — the repository turns those into
/// `Result`s.
abstract interface class OutboxLocalDataSource {
  Stream<List<OutboxEntry>> watchAll();

  /// Every `pending` row, oldest first. Whether one is actually *due* is
  /// [OutboxEntry.isDueAt]'s call, not SQL's — one rule, one place.
  Future<List<OutboxEntry>> pending();

  Future<void> upsert(OutboxEntry entry);

  Future<void> delete(String id);

  Future<void> resetInFlight();

  Future<void> deleteSent();
}

class DriftOutboxLocalDataSource implements OutboxLocalDataSource {
  const DriftOutboxLocalDataSource(this._db);

  final AppDatabase _db;

  @override
  Stream<List<OutboxEntry>> watchAll() {
    final query = _db.select(_db.outboxTransfers)
      ..orderBy([(t) => OrderingTerm.asc(t.queuedAt)]);
    return query.watch().map(_toDomain);
  }

  @override
  Future<List<OutboxEntry>> pending() async {
    final query = _db.select(_db.outboxTransfers)
      ..where((t) => t.status.equals(OutboxStatus.pending.name))
      ..orderBy([(t) => OrderingTerm.asc(t.queuedAt)]);
    return _toDomain(await query.get());
  }

  @override
  Future<void> upsert(OutboxEntry entry) {
    final destination = _columnsFor(entry.request.destination);
    return _db.into(_db.outboxTransfers).insertOnConflictUpdate(
          OutboxTransfersCompanion.insert(
            id: entry.id,
            transferId: entry.transferId,
            idempotencyKey: entry.idempotencyKey,
            status: entry.status.name,
            attention: Value(entry.attention?.name),
            attempts: Value(entry.attempts),
            serverErrors: Value(entry.serverErrors),
            queuedAt: entry.queuedAt,
            nextAttemptAt: Value(entry.nextAttemptAt),
            reference: Value(entry.reference),
            sourceAccountId: entry.request.sourceAccountId,
            destinationType: destination.type,
            destinationAccountId: Value(destination.accountId),
            destinationBeneficiaryId: Value(destination.beneficiaryId),
            destinationIban: Value(destination.iban),
            destinationHolderName: Value(destination.holderName),
            amountMinor: entry.request.amount.minorUnits,
            currency: entry.request.amount.currency.code,
            note: Value(entry.request.note),
            scheduledFor: Value(entry.request.scheduledFor),
            destinationLabel: entry.snapshot.destinationLabel,
            destinationDetail: entry.snapshot.destinationDetail,
            totalDebitMinor: entry.snapshot.totalDebit.minorUnits,
            destinationAmountMinor: entry.snapshot.destinationAmount.minorUnits,
            destinationCurrency: entry.snapshot.destinationAmount.currency.code,
          ),
        );
  }

  @override
  Future<void> delete(String id) {
    return (_db.delete(_db.outboxTransfers)..where((t) => t.id.equals(id)))
        .go();
  }

  @override
  Future<void> resetInFlight() {
    return (_db.update(_db.outboxTransfers)
          ..where((t) => t.status.equals(OutboxStatus.inFlight.name)))
        .write(
      OutboxTransfersCompanion(
        status: Value(OutboxStatus.pending.name),
        nextAttemptAt: const Value(null),
      ),
    );
  }

  @override
  Future<void> deleteSent() {
    return (_db.delete(_db.outboxTransfers)
          ..where((t) => t.status.equals(OutboxStatus.sent.name)))
        .go();
  }

  /// A row this build cannot faithfully rebuild is skipped.
  ///
  /// Unreachable in practice — the write path only ever stores a
  /// validated [Iban] and a supported [Currency] — but if it ever
  /// happens, replaying a transfer we cannot describe to the user is
  /// worse than not replaying it. Same stance as `BeneficiariesDto`,
  /// which drops payees it cannot represent rather than coercing them.
  List<OutboxEntry> _toDomain(List<OutboxTransfer> rows) => [
        for (final row in rows)
          if (_entryFromRow(row) case final entry?) entry,
      ];

  OutboxEntry? _entryFromRow(OutboxTransfer row) {
    final destination = _destinationFromRow(row);
    final currency = Currency.tryFromCode(row.currency);
    final destinationCurrency = Currency.tryFromCode(row.destinationCurrency);
    if (destination == null ||
        currency == null ||
        destinationCurrency == null) {
      return null;
    }

    return OutboxEntry(
      id: row.id,
      transferId: row.transferId,
      idempotencyKey: row.idempotencyKey,
      request: TransferRequest(
        sourceAccountId: row.sourceAccountId,
        destination: destination,
        amount: Money.fromMinorUnits(row.amountMinor, currency),
        note: row.note,
        scheduledFor: row.scheduledFor,
      ),
      snapshot: OutboxSnapshot(
        destinationLabel: row.destinationLabel,
        destinationDetail: row.destinationDetail,
        totalDebit: Money.fromMinorUnits(row.totalDebitMinor, currency),
        destinationAmount: Money.fromMinorUnits(
          row.destinationAmountMinor,
          destinationCurrency,
        ),
      ),
      queuedAt: row.queuedAt,
      // An unknown status degrades to `needsAttention`, never to
      // `pending`: the honest failure mode for a money movement is to
      // stop and ask, not to send something we cannot classify.
      status: OutboxStatus.values.asNameMap()[row.status] ??
          OutboxStatus.needsAttention,
      attempts: row.attempts,
      serverErrors: row.serverErrors,
      nextAttemptAt: row.nextAttemptAt,
      attention: row.attention == null
          ? null
          : OutboxAttention.values.asNameMap()[row.attention!],
      reference: row.reference,
    );
  }

  TransferDestination? _destinationFromRow(OutboxTransfer row) {
    switch (row.destinationType) {
      case 'own':
        final accountId = row.destinationAccountId;
        return accountId == null ? null : OwnAccountDestination(accountId);
      case 'beneficiary':
        final id = row.destinationBeneficiaryId;
        return id == null ? null : BeneficiaryDestination(id);
      case 'iban':
        final iban = Iban.tryParse(row.destinationIban ?? '');
        final holder = row.destinationHolderName;
        if (iban == null || holder == null) return null;
        return IbanDestination(iban: iban, holderName: holder);
      default:
        return null;
    }
  }

  _DestinationColumns _columnsFor(TransferDestination destination) {
    return switch (destination) {
      OwnAccountDestination(:final accountId) => (
          type: 'own',
          accountId: accountId,
          beneficiaryId: null,
          iban: null,
          holderName: null,
        ),
      BeneficiaryDestination(:final beneficiaryId) => (
          type: 'beneficiary',
          accountId: null,
          beneficiaryId: beneficiaryId,
          iban: null,
          holderName: null,
        ),
      IbanDestination(:final iban, :final holderName) => (
          type: 'iban',
          accountId: null,
          beneficiaryId: null,
          iban: iban.value,
          holderName: holderName,
        ),
    };
  }
}
