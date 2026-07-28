import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/core/result/result.dart';
import 'package:vaulta/features/savings/domain/entities/pot.dart';

/// The savings-pot store.
///
/// Deliberately **not** a money-movement contract: funding and draining a
/// pot ride the transfer rails via `PotDestination`, so they inherit the
/// idempotency key, the quote/confirm split and the offline outbox for
/// free (handoff 9d §12.2). This repository only reads the pot list and
/// opens new pots — the two things transfers cannot express.
abstract interface class PotsRepository {
  /// The user's pots, newest-relevant first as the server orders them.
  Future<Result<List<Pot>, Failure>> getPots();

  /// Opens a new, empty pot on [accountId]. [goal] is optional — an
  /// open-ended pot has no target. The new pot's balance starts at zero
  /// in the account's currency; funding it is a separate transfer.
  Future<Result<Pot, Failure>> createPot({
    required String accountId,
    required String name,
    Money? goal,
  });
}
