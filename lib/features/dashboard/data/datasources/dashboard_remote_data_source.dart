import 'package:dio/dio.dart';
import 'package:vaulta/features/dashboard/data/models/dashboard_dtos.dart';

/// Talks to the dashboard endpoint. Throws [DioException]s; the repository
/// is the layer that turns those into `Result`s.
class DashboardRemoteDataSource {
  const DashboardRemoteDataSource(this._dio);

  final Dio _dio;

  Future<DashboardSummaryDto> summary() async {
    final response = await _dio.get<Map<String, dynamic>>('/dashboard/summary');
    return DashboardSummaryDto.fromJson(response.data!);
  }
}
