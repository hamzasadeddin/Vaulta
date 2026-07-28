import 'package:dio/dio.dart';
import 'package:vaulta/features/savings/data/models/pot_dtos.dart';

/// Thin Dio wrapper for `/pots`. Throws `DioException` on failure — the
/// repository turns exceptions into `Result`s. Money crosses as integer
/// minor units, the same wire convention as every other endpoint.
class PotsRemoteDataSource {
  const PotsRemoteDataSource(this._dio);

  final Dio _dio;

  Future<PotsDto> pots() async {
    final response = await _dio.get<Map<String, dynamic>>('/pots');
    return PotsDto.fromJson(response.data ?? const {});
  }

  /// Opens a new pot. Funding is a separate transfer, so no amount travels
  /// here — only the account, the name and an optional target.
  Future<PotDto> create({
    required String accountId,
    required String name,
    int? goalMinor,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/pots',
      data: {
        'accountId': accountId,
        'name': name,
        if (goalMinor != null) 'goalMinor': goalMinor,
      },
    );
    return PotDto.fromJson(response.data ?? const {});
  }
}
