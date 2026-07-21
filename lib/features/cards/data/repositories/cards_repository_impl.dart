import 'package:vaulta/core/error/exception_mapper.dart';
import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/core/result/result.dart';
import 'package:vaulta/features/cards/data/datasources/cards_remote_data_source.dart';
import 'package:vaulta/features/cards/domain/entities/bank_card.dart';
import 'package:vaulta/features/cards/domain/repositories/cards_repository.dart';

/// Remote-only implementation — see the repository contract for why card
/// state is never cached.
class CardsRepositoryImpl implements CardsRepository {
  const CardsRepositoryImpl({required CardsRemoteDataSource remote})
      : _remote = remote;

  final CardsRemoteDataSource _remote;

  @override
  Future<Result<List<BankCard>, Failure>> getCards() {
    return runCatching(() async => (await _remote.cards()).toDomain());
  }

  @override
  Future<Result<BankCard, Failure>> setCardFrozen({
    required String cardId,
    required bool frozen,
  }) {
    return runCatching(
      () async =>
          (await _remote.setFrozen(cardId: cardId, frozen: frozen)).toDomain(),
    );
  }

  @override
  Future<Result<BankCard, Failure>> updateCardLimits({
    required String cardId,
    required Money daily,
    required Money monthly,
  }) {
    return runCatching(() async {
      // Money → wire happens here, at the boundary, via minor units — the
      // mirror of `Money.fromMinorUnits` on the way in.
      final dto = await _remote.updateLimits(
        cardId: cardId,
        dailyMinor: daily.minorUnits.toInt(),
        monthlyMinor: monthly.minorUnits.toInt(),
      );
      return dto.toDomain();
    });
  }

  @override
  Future<Result<CardPan, Failure>> revealPan(String cardId) {
    return runCatching(
      () async => (await _remote.revealPan(cardId)).toDomain(),
    );
  }
}
