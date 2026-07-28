import 'package:vaulta/core/error/exception_mapper.dart';
import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/core/result/result.dart';
import 'package:vaulta/features/savings/data/datasources/pots_remote_data_source.dart';
import 'package:vaulta/features/savings/domain/entities/pot.dart';
import 'package:vaulta/features/savings/domain/repositories/pots_repository.dart';

/// Remote-only. Pots are a small, always-fresh read: a stale pot balance
/// is worse than a spinner (it is money the user is deciding whether to
/// move), and the transfer that funds it already invalidates every cached
/// balance — so there is no local cache to keep in sync.
class PotsRepositoryImpl implements PotsRepository {
  const PotsRepositoryImpl({required PotsRemoteDataSource remote})
      : _remote = remote;

  final PotsRemoteDataSource _remote;

  @override
  Future<Result<List<Pot>, Failure>> getPots() {
    return runCatching(() async => (await _remote.pots()).toDomain());
  }

  @override
  Future<Result<Pot, Failure>> createPot({
    required String accountId,
    required String name,
    Money? goal,
  }) async {
    final created = await runCatching(
      () async => _remote.create(
        accountId: accountId,
        name: name,
        goalMinor: goal?.minorUnits.toInt(),
      ),
    );
    return created.flatMap((dto) {
      final pot = dto.toDomainOrNull();
      // The server just created it, so an unrepresentable row here means a
      // currency the client cannot render — surface it rather than return a
      // pot with a coerced amount.
      return pot == null
          ? const Result.failure(
              UnexpectedFailure(
                message: 'Pot created in an unsupported currency',
              ),
            )
          : Result.success(pot);
    });
  }
}
