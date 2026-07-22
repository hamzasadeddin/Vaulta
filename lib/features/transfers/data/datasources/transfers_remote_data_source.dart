import 'package:dio/dio.dart';
import 'package:vaulta/core/network/interceptors/idempotency_interceptor.dart';
import 'package:vaulta/features/transfers/data/models/transfer_dtos.dart';

/// Thin Dio wrapper for `/beneficiaries` and `/transfers*`. Throws
/// `DioException` on failure — the repository turns exceptions into
/// `Result`s.
class TransfersRemoteDataSource {
  const TransfersRemoteDataSource(this._dio);

  final Dio _dio;

  Future<BeneficiariesDto> beneficiaries() async {
    final response = await _dio.get<Map<String, dynamic>>('/beneficiaries');
    return BeneficiariesDto.fromJson(response.data ?? const {});
  }

  /// Creates a priced draft. The interceptor stamps its own key here —
  /// creating two drafts is harmless, since a draft moves no money.
  Future<TransferQuoteDto> create({
    required String sourceAccountId,
    required String destinationType,
    required int amountMinor,
    String? destinationAccountId,
    String? destinationBeneficiaryId,
    String? destinationIban,
    String? destinationHolderName,
    String? note,
    String? scheduledFor,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/transfers',
      data: {
        'sourceAccountId': sourceAccountId,
        'amountMinor': amountMinor,
        'destination': {
          'type': destinationType,
          if (destinationAccountId != null) 'accountId': destinationAccountId,
          if (destinationBeneficiaryId != null)
            'beneficiaryId': destinationBeneficiaryId,
          if (destinationIban != null) 'iban': destinationIban,
          if (destinationHolderName != null)
            'holderName': destinationHolderName,
        },
        if (note != null) 'note': note,
        if (scheduledFor != null) 'scheduledFor': scheduledFor,
      },
    );
    return TransferQuoteDto.fromJson(response.data ?? const {});
  }

  /// Executes a draft.
  ///
  /// The `Idempotency-Key` is set **explicitly** to the quote's key
  /// rather than left to [IdempotencyInterceptor]'s per-request UUID:
  /// that interceptor only stamps a key when the caller has not, exactly
  /// so a business operation can own its own scope. Because the header
  /// rides on the `RequestOptions`, a `dio_smart_retry` re-send carries
  /// the identical key — which is what makes an interrupted confirm safe
  /// to retry.
  Future<TransferDto> confirm({
    required String transferId,
    required String idempotencyKey,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/transfers/$transferId/confirm',
      options: Options(
        headers: {IdempotencyInterceptor.header: idempotencyKey},
      ),
    );
    return TransferDto.fromJson(response.data ?? const {});
  }
}
