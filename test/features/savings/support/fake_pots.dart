import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/core/result/result.dart';
import 'package:vaulta/features/savings/domain/entities/pot.dart';
import 'package:vaulta/features/savings/domain/repositories/pots_repository.dart';

/// An in-memory [PotsRepository] for tests — no Dio, no mock interceptor.
/// Faithful enough to assert against: it records calls and returns what
/// the test seeds, and [createPot] appends so a follow-up [getPots] sees
/// the new pot.
class FakePotsRepository implements PotsRepository {
  FakePotsRepository({
    List<Pot> pots = const [],
    this.getFailure,
    this.createFailure,
    this.created,
  }) : pots = List.of(pots);

  List<Pot> pots;
  Failure? getFailure;
  Failure? createFailure;

  /// If set, [createPot] returns this pot; otherwise it fabricates a
  /// zero-balance pot from the arguments.
  Pot? created;

  int getPotsCalls = 0;
  int createPotCalls = 0;
  ({String accountId, String name, Money? goal})? lastCreate;

  @override
  Future<Result<List<Pot>, Failure>> getPots() async {
    getPotsCalls++;
    final failure = getFailure;
    return failure == null
        ? Result.success(List.of(pots))
        : Result.failure(failure);
  }

  @override
  Future<Result<Pot, Failure>> createPot({
    required String accountId,
    required String name,
    Money? goal,
  }) async {
    createPotCalls++;
    lastCreate = (accountId: accountId, name: name, goal: goal);
    final failure = createFailure;
    if (failure != null) return Result.failure(failure);
    final pot = created ??
        Pot(
          id: 'pot_new',
          accountId: accountId,
          name: name,
          balance: Money.zero(goal?.currency ?? Currency.usd),
          goal: goal,
        );
    pots = [...pots, pot];
    return Result.success(pot);
  }
}
