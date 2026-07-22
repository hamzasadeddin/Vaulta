import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/result/result.dart';
import 'package:vaulta/core/usecase/use_case.dart';
import 'package:vaulta/features/transfers/domain/entities/beneficiary.dart';
import 'package:vaulta/features/transfers/domain/entities/transfer.dart';
import 'package:vaulta/features/transfers/domain/repositories/transfers_repository.dart';

class GetBeneficiaries implements UseCase<NoParams, List<Beneficiary>> {
  const GetBeneficiaries(this._repository);

  final TransfersRepository _repository;

  @override
  Future<Result<List<Beneficiary>, Failure>> call(NoParams input) =>
      _repository.getBeneficiaries();
}

class CreateTransfer implements UseCase<TransferRequest, TransferQuote> {
  const CreateTransfer(this._repository);

  final TransfersRepository _repository;

  @override
  Future<Result<TransferQuote, Failure>> call(TransferRequest input) =>
      _repository.createTransfer(input);
}

class ConfirmTransferParams {
  const ConfirmTransferParams({
    required this.transferId,
    required this.idempotencyKey,
  });

  final String transferId;
  final String idempotencyKey;
}

class ConfirmTransfer implements UseCase<ConfirmTransferParams, Transfer> {
  const ConfirmTransfer(this._repository);

  final TransfersRepository _repository;

  @override
  Future<Result<Transfer, Failure>> call(ConfirmTransferParams input) =>
      _repository.confirmTransfer(
        transferId: input.transferId,
        idempotencyKey: input.idempotencyKey,
      );
}
