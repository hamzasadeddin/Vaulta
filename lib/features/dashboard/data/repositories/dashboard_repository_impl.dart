import 'package:vaulta/core/error/exception_mapper.dart';
import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/result/result.dart';
import 'package:vaulta/features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:vaulta/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:vaulta/features/dashboard/domain/repositories/dashboard_repository.dart';

/// Fetches the dashboard read model and maps wire DTOs to domain
/// entities. No exception escapes this layer.
class DashboardRepositoryImpl implements DashboardRepository {
  const DashboardRepositoryImpl({required DashboardRemoteDataSource remote})
      : _remote = remote;

  final DashboardRemoteDataSource _remote;

  @override
  Future<Result<DashboardSummary, Failure>> getSummary() =>
      runCatching(() async => (await _remote.summary()).toDomain());
}
