import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/core/result/result.dart';
import 'package:vaulta/core/usecase/use_case.dart';
import 'package:vaulta/features/savings/domain/entities/pot.dart';
import 'package:vaulta/features/savings/domain/repositories/pots_repository.dart';

class GetPots implements UseCase<NoParams, List<Pot>> {
  const GetPots(this._repository);

  final PotsRepository _repository;

  @override
  Future<Result<List<Pot>, Failure>> call(NoParams input) =>
      _repository.getPots();
}

class CreatePotParams {
  const CreatePotParams({
    required this.accountId,
    required this.name,
    this.goal,
  });

  final String accountId;
  final String name;
  final Money? goal;
}

class CreatePot implements UseCase<CreatePotParams, Pot> {
  const CreatePot(this._repository);

  final PotsRepository _repository;

  @override
  Future<Result<Pot, Failure>> call(CreatePotParams input) =>
      _repository.createPot(
        accountId: input.accountId,
        name: input.name,
        goal: input.goal,
      );
}
