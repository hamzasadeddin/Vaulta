import 'package:dio/dio.dart';
import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/result/result.dart';

/// Maps any thrown object to a [Failure]. This is the single choke point
/// where exceptions become values — call it only at repository boundaries.
Failure mapExceptionToFailure(Object error, [StackTrace? stackTrace]) {
  return switch (error) {
    Failure() => error,
    DioException() => _mapDioException(error, stackTrace),
    FormatException() => UnexpectedFailure(
        message: 'Malformed data: ${error.message}',
        cause: error,
        stackTrace: stackTrace,
      ),
    _ => UnexpectedFailure(
        message: error.toString(),
        cause: error,
        stackTrace: stackTrace,
      ),
  };
}

/// Runs [body], capturing anything thrown into a `Result`.
///
/// Repository implementations wrap every data-source call with this so no
/// exception escapes the data layer.
Future<Result<T, Failure>> runCatching<T>(Future<T> Function() body) async {
  try {
    return Result.success(await body());
  } on Object catch (error, stackTrace) {
    return Result.failure(mapExceptionToFailure(error, stackTrace));
  }
}

Failure _mapDioException(DioException error, StackTrace? stackTrace) {
  final st = stackTrace ?? error.stackTrace;
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.transformTimeout:
      return TimeoutFailure(cause: error, stackTrace: st);
    case DioExceptionType.connectionError:
      return NetworkFailure(cause: error, stackTrace: st);
    case DioExceptionType.cancel:
      return CancelledFailure(cause: error, stackTrace: st);
    case DioExceptionType.badCertificate:
      return NetworkFailure(
        message: 'TLS certificate could not be verified',
        cause: error,
        stackTrace: st,
      );
    case DioExceptionType.badResponse:
      return _mapBadResponse(error, st);
    case DioExceptionType.unknown:
      return UnexpectedFailure(
        message: error.message ?? 'Unknown network error',
        cause: error,
        stackTrace: st,
      );
  }
}

Failure _mapBadResponse(DioException error, StackTrace? stackTrace) {
  final statusCode = error.response?.statusCode;
  final envelope = _envelopeOf(error.response?.data);
  final message = envelope?['message'] as String? ??
      'Request failed with status $statusCode';
  final errorCode = envelope?['code'] as String?;

  if (statusCode == 401 || statusCode == 403) {
    return AuthFailure(message: message, cause: error, stackTrace: stackTrace);
  }
  if (statusCode == 422) {
    return ValidationFailure(
      message: message,
      fieldErrors: _fieldErrorsOf(envelope),
      cause: error,
      stackTrace: stackTrace,
    );
  }
  return ServerFailure(
    message: message,
    statusCode: statusCode,
    errorCode: errorCode,
    cause: error,
    stackTrace: stackTrace,
  );
}

Map<String, dynamic>? _envelopeOf(Object? data) {
  return data is Map<String, dynamic> ? data : null;
}

Map<String, List<String>> _fieldErrorsOf(Map<String, dynamic>? envelope) {
  final raw = envelope?['errors'];
  if (raw is! Map<String, dynamic>) return const {};
  return raw.map(
    (field, messages) => MapEntry(
      field,
      messages is List
          ? messages.map((m) => m.toString()).toList()
          : <String>[messages.toString()],
    ),
  );
}
