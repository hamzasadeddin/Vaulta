import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

/// Stamps every mutating request with an `Idempotency-Key` header so the
/// backend can dedupe retries (double-tap on "Confirm transfer", automatic
/// retry after a timeout whose original request actually landed, ...).
///
/// The key is set once per logical request: `dio_smart_retry` re-sends the
/// same [RequestOptions], so retries carry the *same* key — which is exactly
/// the point. Callers may pre-set the header to scope idempotency to a
/// business operation (e.g. a transfer draft id).
class IdempotencyInterceptor extends Interceptor {
  IdempotencyInterceptor({Uuid uuid = const Uuid()}) : _uuid = uuid;

  static const header = 'Idempotency-Key';

  static const _mutatingMethods = {'POST', 'PUT', 'PATCH', 'DELETE'};

  final Uuid _uuid;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final method = options.method.toUpperCase();
    // RequestOptions.headers is a case-insensitive map, so this also
    // detects caller-provided keys like 'idempotency-key'.
    if (_mutatingMethods.contains(method) &&
        !options.headers.containsKey(header)) {
      options.headers[header] = _uuid.v4();
    }
    handler.next(options);
  }
}
