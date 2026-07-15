import 'package:meta/meta.dart';

/// A hand-rolled `Result` type (meta annotations only — no fp packages).
///
/// Every layer boundary (repository → use case → provider) returns
/// `Result<T, Failure>` — exceptions never cross layers.
sealed class Result<T, F> {
  const Result();

  const factory Result.success(T value) = Success<T, F>;

  const factory Result.failure(F failure) = Failed<T, F>;

  bool get isSuccess => this is Success<T, F>;

  bool get isFailure => this is Failed<T, F>;

  T? get valueOrNull => switch (this) {
        Success<T, F>(:final value) => value,
        Failed<T, F>() => null,
      };

  F? get failureOrNull => switch (this) {
        Success<T, F>() => null,
        Failed<T, F>(:final failure) => failure,
      };

  /// Collapses both branches into a single value. Exhaustive by construction.
  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(F failure) onFailure,
  }) {
    return switch (this) {
      Success<T, F>(:final value) => onSuccess(value),
      Failed<T, F>(:final failure) => onFailure(failure),
    };
  }

  /// Transforms the success value, propagating failure untouched.
  Result<R, F> map<R>(R Function(T value) transform) {
    return switch (this) {
      Success<T, F>(:final value) => Result.success(transform(value)),
      Failed<T, F>(:final failure) => Result.failure(failure),
    };
  }

  /// Transforms the failure, propagating success untouched.
  Result<T, R> mapFailure<R>(R Function(F failure) transform) {
    return switch (this) {
      Success<T, F>(:final value) => Result.success(value),
      Failed<T, F>(:final failure) => Result.failure(transform(failure)),
    };
  }

  /// Chains a result-producing computation (monadic bind).
  Result<R, F> flatMap<R>(Result<R, F> Function(T value) transform) {
    return switch (this) {
      Success<T, F>(:final value) => transform(value),
      Failed<T, F>(:final failure) => Result.failure(failure),
    };
  }

  T getOrElse(T Function(F failure) orElse) {
    return switch (this) {
      Success<T, F>(:final value) => value,
      Failed<T, F>(:final failure) => orElse(failure),
    };
  }

  /// Side-effect hooks.
  void onSuccess(void Function(T value) action) {
    if (this case Success<T, F>(:final value)) action(value);
  }

  void onFailure(void Function(F failure) action) {
    if (this case Failed<T, F>(:final failure)) action(failure);
  }
}

@immutable
final class Success<T, F> extends Result<T, F> {
  const Success(this.value);

  final T value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Success<T, F> && other.value == value;

  @override
  int get hashCode => Object.hash(runtimeType, value);

  @override
  String toString() => 'Success<$T>($value)';
}

@immutable
final class Failed<T, F> extends Result<T, F> {
  const Failed(this.failure);

  final F failure;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failed<T, F> && other.failure == failure;

  @override
  int get hashCode => Object.hash(runtimeType, failure);

  @override
  String toString() => 'Failed<$T>($failure)';
}
