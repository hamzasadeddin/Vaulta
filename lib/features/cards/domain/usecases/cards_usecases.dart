import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/core/result/result.dart';
import 'package:vaulta/core/usecase/use_case.dart';
import 'package:vaulta/features/cards/domain/entities/bank_card.dart';
import 'package:vaulta/features/cards/domain/repositories/cards_repository.dart';

class GetCards implements UseCase<NoParams, List<BankCard>> {
  const GetCards(this._repository);

  final CardsRepository _repository;

  @override
  Future<Result<List<BankCard>, Failure>> call(NoParams input) =>
      _repository.getCards();
}

class SetCardFrozenParams {
  const SetCardFrozenParams({required this.cardId, required this.frozen});

  final String cardId;
  final bool frozen;
}

class SetCardFrozen implements UseCase<SetCardFrozenParams, BankCard> {
  const SetCardFrozen(this._repository);

  final CardsRepository _repository;

  @override
  Future<Result<BankCard, Failure>> call(SetCardFrozenParams input) =>
      _repository.setCardFrozen(cardId: input.cardId, frozen: input.frozen);
}

class UpdateCardLimitsParams {
  const UpdateCardLimitsParams({
    required this.cardId,
    required this.daily,
    required this.monthly,
  });

  final String cardId;
  final Money daily;
  final Money monthly;
}

class UpdateCardLimits implements UseCase<UpdateCardLimitsParams, BankCard> {
  const UpdateCardLimits(this._repository);

  final CardsRepository _repository;

  @override
  Future<Result<BankCard, Failure>> call(UpdateCardLimitsParams input) =>
      _repository.updateCardLimits(
        cardId: input.cardId,
        daily: input.daily,
        monthly: input.monthly,
      );
}

class RevealCardPan implements UseCase<String, CardPan> {
  const RevealCardPan(this._repository);

  final CardsRepository _repository;

  @override
  Future<Result<CardPan, Failure>> call(String input) =>
      _repository.revealPan(input);
}
