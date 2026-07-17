import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/result/result.dart';
import 'package:vaulta/core/usecase/use_case.dart';
import 'package:vaulta/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:vaulta/features/dashboard/domain/repositories/dashboard_repository.dart';

/// Fetches everything the dashboard shows in one round trip.
class GetDashboardSummary implements UseCase<NoParams, DashboardSummary> {
  const GetDashboardSummary(this._repository);

  final DashboardRepository _repository;

  @override
  Future<Result<DashboardSummary, Failure>> call(NoParams input) =>
      _repository.getSummary();
}
