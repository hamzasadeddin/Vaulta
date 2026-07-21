import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/core/result/result.dart';
import 'package:vaulta/features/cards/domain/entities/bank_card.dart';

/// Domain contract for the cards feature. Remote-only, like transactions:
/// card state (frozen, limits) is server truth that must never be served
/// stale from a cache — a card the user believes is frozen has to *be*
/// frozen, so every read goes to the source.
abstract interface class CardsRepository {
  Future<Result<List<BankCard>, Failure>> getCards();

  /// Freezes or unfreezes a card. Returns the server's updated card so
  /// optimistic UI can reconcile against truth.
  Future<Result<BankCard, Failure>> setCardFrozen({
    required String cardId,
    required bool frozen,
  });

  /// Replaces both spending limits. Returns the updated card.
  Future<Result<BankCard, Failure>> updateCardLimits({
    required String cardId,
    required Money daily,
    required Money monthly,
  });

  /// Fetches the full PAN for an explicit, user-initiated reveal. The
  /// response body is marked sensitive end to end — it never reaches the
  /// network log sink.
  Future<Result<CardPan, Failure>> revealPan(String cardId);
}
