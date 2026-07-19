import 'package:dio/dio.dart';
import 'package:vaulta/features/transactions/data/models/transaction_dtos.dart';
import 'package:vaulta/features/transactions/domain/entities/transaction.dart';
import 'package:vaulta/features/transactions/domain/entities/transaction_filter.dart';

/// Thin Dio wrapper for `/transactions*`. Throws `DioException` on failure —
/// the repository is the layer that turns exceptions into `Result`s.
class TransactionsRemoteDataSource {
  const TransactionsRemoteDataSource(this._dio);

  final Dio _dio;

  Future<TransactionsPageDto> transactions({
    required TransactionFilter filter,
    required int limit,
    String? cursor,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/transactions',
      queryParameters: {
        'limit': limit,
        if (cursor != null) 'cursor': cursor,
        if (filter.accountId != null) 'accountId': filter.accountId,
        if (filter.category != null) 'category': filter.category!.name,
        if (filter.status != null) 'status': filter.status!.name,
        if (filter.normalizedQuery.isNotEmpty) 'q': filter.normalizedQuery,
      },
    );
    return TransactionsPageDto.fromJson(response.data ?? const {});
  }

  Future<TransactionDto> transaction(String transactionId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/transactions/$transactionId',
    );
    return TransactionDto.fromJson(response.data ?? const {});
  }

  Future<DisputeReceiptDto> submitDispute({
    required String transactionId,
    required DisputeReason reason,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/transactions/$transactionId/dispute',
      data: {'reason': reason.name},
    );
    return DisputeReceiptDto.fromJson(response.data ?? const {});
  }
}
