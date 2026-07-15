/// Domain-level failure taxonomy. Sealed so presentation can switch
/// exhaustively when mapping failures to user-facing copy.
sealed class Failure {
  const Failure({required this.message, this.cause, this.stackTrace});

  /// Developer-facing description. UI copy comes from l10n, keyed off the
  /// concrete type — never render [message] to users directly.
  final String message;

  final Object? cause;
  final StackTrace? stackTrace;

  @override
  // Log/debug readability only; losing the type name under minification
  // is acceptable, and UI copy never comes from toString.
  // ignore: no_runtimetype_tostring
  String toString() => '$runtimeType($message)';
}

/// No connectivity / DNS / socket-level trouble.
final class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'Unable to reach the server',
    super.cause,
    super.stackTrace,
  });
}

/// The request went out but the deadline elapsed.
final class TimeoutFailure extends Failure {
  const TimeoutFailure({
    super.message = 'The request timed out',
    super.cause,
    super.stackTrace,
  });
}

/// Non-2xx response from the API.
final class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    this.statusCode,
    this.errorCode,
    super.cause,
    super.stackTrace,
  });

  final int? statusCode;

  /// Machine-readable code from the API envelope, when present.
  final String? errorCode;

  @override
  String toString() => 'ServerFailure($statusCode, $errorCode, $message)';
}

/// 401/403 — expired session, revoked token, insufficient scope.
final class AuthFailure extends Failure {
  const AuthFailure({
    super.message = 'Authentication required',
    super.cause,
    super.stackTrace,
  });
}

/// Input rejected by the server or by local validation.
final class ValidationFailure extends Failure {
  const ValidationFailure({
    super.message = 'Validation failed',
    this.fieldErrors = const {},
    super.cause,
    super.stackTrace,
  });

  /// Field name → list of error messages.
  final Map<String, List<String>> fieldErrors;
}

/// Local persistence (Drift / secure storage) problem.
final class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Local storage error',
    super.cause,
    super.stackTrace,
  });
}

/// The caller cancelled the request; usually safe to ignore in UI.
final class CancelledFailure extends Failure {
  const CancelledFailure({
    super.message = 'Request cancelled',
    super.cause,
    super.stackTrace,
  });
}

/// Anything we did not anticipate. Always report these to crash tooling.
final class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    super.message = 'Something went wrong',
    super.cause,
    super.stackTrace,
  });
}
