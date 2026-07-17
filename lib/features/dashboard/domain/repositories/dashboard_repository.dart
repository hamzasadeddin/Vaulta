import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/result/result.dart';
import 'package:vaulta/features/dashboard/domain/entities/dashboard_summary.dart';

/// Domain contract for the dashboard read model.
///
/// A single read today; account-level feeds arrive with Phase 5.
// Mockable seam implemented by the data layer, mirroring AuthRepository.
// ignore: one_member_abstracts
abstract interface class DashboardRepository {
  Future<Result<DashboardSummary, Failure>> getSummary();
}
