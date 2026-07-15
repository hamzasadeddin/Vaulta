import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vaulta/core/error/exception_mapper.dart';
import 'package:vaulta/core/error/failure.dart';

DioException _dioError({
  DioExceptionType type = DioExceptionType.badResponse,
  int? statusCode,
  Object? data,
}) {
  final options = RequestOptions(path: '/test');
  return DioException(
    requestOptions: options,
    type: type,
    response: statusCode == null
        ? null
        : Response<dynamic>(
            requestOptions: options,
            statusCode: statusCode,
            data: data,
          ),
  );
}

void main() {
  group('mapExceptionToFailure', () {
    test('timeouts map to TimeoutFailure', () {
      for (final type in [
        DioExceptionType.connectionTimeout,
        DioExceptionType.sendTimeout,
        DioExceptionType.receiveTimeout,
      ]) {
        expect(
          mapExceptionToFailure(_dioError(type: type)),
          isA<TimeoutFailure>(),
        );
      }
    });

    test('connection errors map to NetworkFailure', () {
      expect(
        mapExceptionToFailure(
          _dioError(type: DioExceptionType.connectionError),
        ),
        isA<NetworkFailure>(),
      );
    });

    test('cancellation maps to CancelledFailure', () {
      expect(
        mapExceptionToFailure(_dioError(type: DioExceptionType.cancel)),
        isA<CancelledFailure>(),
      );
    });

    test('401/403 map to AuthFailure', () {
      expect(
        mapExceptionToFailure(_dioError(statusCode: 401)),
        isA<AuthFailure>(),
      );
      expect(
        mapExceptionToFailure(_dioError(statusCode: 403)),
        isA<AuthFailure>(),
      );
    });

    test('422 maps to ValidationFailure with field errors', () {
      final failure = mapExceptionToFailure(
        _dioError(
          statusCode: 422,
          data: {
            'message': 'Invalid IBAN',
            'errors': {
              'iban': ['checksum failed'],
            },
          },
        ),
      );
      expect(failure, isA<ValidationFailure>());
      final validation = failure as ValidationFailure;
      expect(validation.message, 'Invalid IBAN');
      expect(validation.fieldErrors['iban'], ['checksum failed']);
    });

    test('5xx maps to ServerFailure with metadata', () {
      final failure = mapExceptionToFailure(
        _dioError(
          statusCode: 503,
          data: {'message': 'maintenance', 'code': 'MAINTENANCE'},
        ),
      );
      expect(failure, isA<ServerFailure>());
      final server = failure as ServerFailure;
      expect(server.statusCode, 503);
      expect(server.errorCode, 'MAINTENANCE');
    });

    test('passes through existing Failures and wraps unknowns', () {
      const original = CacheFailure();
      expect(mapExceptionToFailure(original), same(original));
      expect(
        mapExceptionToFailure(StateError('boom')),
        isA<UnexpectedFailure>(),
      );
      expect(
        mapExceptionToFailure(const FormatException('bad json')),
        isA<UnexpectedFailure>(),
      );
    });
  });

  group('runCatching', () {
    test('wraps success', () async {
      final result = await runCatching(() async => 7);
      expect(result.valueOrNull, 7);
    });

    test('captures thrown exceptions as failures', () async {
      final result = await runCatching<int>(
        () async => throw _dioError(statusCode: 500),
      );
      expect(result.failureOrNull, isA<ServerFailure>());
    });
  });
}
