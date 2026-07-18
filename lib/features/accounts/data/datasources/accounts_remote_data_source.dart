import 'package:dio/dio.dart';
import 'package:vaulta/features/accounts/data/models/account_dtos.dart';

/// Thin Dio wrapper for `/accounts*`. Throws `DioException` on failure —
/// the repository is the layer that turns exceptions into `Result`s.
class AccountsRemoteDataSource {
  const AccountsRemoteDataSource(this._dio);

  final Dio _dio;

  Future<AccountsResponseDto> accounts() async {
    final response = await _dio.get<Map<String, dynamic>>('/accounts');
    return AccountsResponseDto.fromJson(response.data ?? const {});
  }

  Future<AccountHistoryDto> history(
    String accountId, {
    required int days,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/accounts/$accountId/history',
      queryParameters: {'days': days},
    );
    return AccountHistoryDto.fromJson(response.data ?? const {});
  }

  Future<StatementsResponseDto> statements(String accountId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/accounts/$accountId/statements',
    );
    return StatementsResponseDto.fromJson(response.data ?? const {});
  }

  Future<StatementDetailDto> statement(
    String accountId,
    String statementId,
  ) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/accounts/$accountId/statements/$statementId',
    );
    return StatementDetailDto.fromJson(response.data ?? const {});
  }
}
