import 'package:dio/dio.dart';
import 'package:vaulta/core/network/sensitive.dart';
import 'package:vaulta/features/cards/data/models/card_dtos.dart';

/// Thin Dio wrapper for `/cards*`. Throws `DioException` on failure — the
/// repository turns exceptions into `Result`s.
class CardsRemoteDataSource {
  const CardsRemoteDataSource(this._dio);

  final Dio _dio;

  Future<CardsDto> cards() async {
    final response = await _dio.get<Map<String, dynamic>>('/cards');
    return CardsDto.fromJson(response.data ?? const {});
  }

  /// Freeze/unfreeze as explicit verbs rather than a status PATCH: the
  /// intent is unambiguous on the wire, and repeating either call is
  /// naturally idempotent server-side.
  Future<CardDto> setFrozen({
    required String cardId,
    required bool frozen,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/cards/$cardId/${frozen ? 'freeze' : 'unfreeze'}',
    );
    return CardDto.fromJson(response.data ?? const {});
  }

  Future<CardDto> updateLimits({
    required String cardId,
    required int dailyMinor,
    required int monthlyMinor,
  }) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      '/cards/$cardId/limits',
      data: {'dailyMinor': dailyMinor, 'monthlyMinor': monthlyMinor},
    );
    return CardDto.fromJson(response.data ?? const {});
  }

  Future<CardPanDto> revealPan(String cardId) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/cards/$cardId/reveal',
      // The response body is a secret — the logger's responseFilter drops
      // it (see core/network/sensitive.dart).
      options: Options(extra: const {kSensitiveResponseBody: true}),
    );
    return CardPanDto.fromJson(response.data ?? const {});
  }
}
