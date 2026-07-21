import 'package:dio/dio.dart' show RequestOptions;

/// Marker key for [RequestOptions.extra]: when `true`, the response body
/// carries secrets (card PAN / CVV) and must never reach the log sink.
///
/// Request *headers* are already unlogged everywhere (§5 invariant); this
/// extends the same guarantee to response *bodies* on the few endpoints
/// that return secrets. `buildDio` wires the Talker logger's
/// `responseFilter` to honour it, so the suppression lives in one place —
/// callers only tag the request.
const kSensitiveResponseBody = 'vaulta.sensitiveResponseBody';
