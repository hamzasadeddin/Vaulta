import 'package:vaulta/core/error/exception_mapper.dart';
import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/result/result.dart';
import 'package:vaulta/features/transfers/data/datasources/transfers_remote_data_source.dart';
import 'package:vaulta/features/transfers/domain/entities/beneficiary.dart';
import 'package:vaulta/features/transfers/domain/entities/transfer.dart';
import 'package:vaulta/features/transfers/domain/repositories/transfers_repository.dart';

/// Remote-only implementation — see the repository contract for why a
/// quote is never cached.
class TransfersRepositoryImpl implements TransfersRepository {
  const TransfersRepositoryImpl({required TransfersRemoteDataSource remote})
      : _remote = remote;

  final TransfersRemoteDataSource _remote;

  @override
  Future<Result<List<Beneficiary>, Failure>> getBeneficiaries() {
    return runCatching(
      () async => (await _remote.beneficiaries()).toDomain(),
    );
  }

  @override
  Future<Result<TransferQuote, Failure>> createTransfer(
    TransferRequest request,
  ) {
    return runCatching(() async {
      // Money → wire happens here, at the boundary, via minor units —
      // the mirror of `Money.fromMinorUnits` on the way in.
      final dto = await switch (request.destination) {
        OwnAccountDestination(:final accountId) => _remote.create(
            sourceAccountId: request.sourceAccountId,
            destinationType: 'own',
            amountMinor: request.amount.minorUnits.toInt(),
            destinationAccountId: accountId,
            note: request.note,
            scheduledFor: request.scheduledFor?.toIso8601String(),
          ),
        BeneficiaryDestination(:final beneficiaryId) => _remote.create(
            sourceAccountId: request.sourceAccountId,
            destinationType: 'beneficiary',
            amountMinor: request.amount.minorUnits.toInt(),
            destinationBeneficiaryId: beneficiaryId,
            note: request.note,
            scheduledFor: request.scheduledFor?.toIso8601String(),
          ),
        IbanDestination(:final iban, :final holderName) => _remote.create(
            sourceAccountId: request.sourceAccountId,
            destinationType: 'iban',
            amountMinor: request.amount.minorUnits.toInt(),
            destinationIban: iban.value,
            destinationHolderName: holderName,
            note: request.note,
            scheduledFor: request.scheduledFor?.toIso8601String(),
          ),
      };
      return dto.toDomain();
    });
  }

  @override
  Future<Result<Transfer, Failure>> confirmTransfer({
    required String transferId,
    required String idempotencyKey,
  }) {
    return runCatching(() async {
      final dto = await _remote.confirm(
        transferId: transferId,
        idempotencyKey: idempotencyKey,
      );
      return dto.toDomain();
    });
  }
}
