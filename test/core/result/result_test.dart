import 'package:flutter_test/flutter_test.dart';
import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/result/result.dart';

void main() {
  group('Result', () {
    const failure = NetworkFailure();

    test('success exposes value and flags', () {
      const result = Result<int, Failure>.success(42);
      expect(result.isSuccess, isTrue);
      expect(result.isFailure, isFalse);
      expect(result.valueOrNull, 42);
      expect(result.failureOrNull, isNull);
    });

    test('failure exposes failure and flags', () {
      const result = Result<int, Failure>.failure(failure);
      expect(result.isSuccess, isFalse);
      expect(result.isFailure, isTrue);
      expect(result.valueOrNull, isNull);
      expect(result.failureOrNull, failure);
    });

    test('fold collapses both branches', () {
      const success = Result<int, Failure>.success(2);
      const failed = Result<int, Failure>.failure(failure);
      expect(
        success.fold(onSuccess: (v) => v * 10, onFailure: (_) => -1),
        20,
      );
      expect(
        failed.fold(onSuccess: (v) => v * 10, onFailure: (_) => -1),
        -1,
      );
    });

    test('map transforms success only', () {
      expect(
        const Result<int, Failure>.success(2).map((v) => '$v!'),
        const Result<String, Failure>.success('2!'),
      );
      expect(
        const Result<int, Failure>.failure(failure).map((v) => '$v!'),
        const Result<String, Failure>.failure(failure),
      );
    });

    test('flatMap chains and short-circuits', () {
      Result<int, Failure> half(int v) => v.isEven
          ? Result.success(v ~/ 2)
          : const Result.failure(ValidationFailure(message: 'odd'));

      expect(
        const Result<int, Failure>.success(8).flatMap(half).flatMap(half),
        const Result<int, Failure>.success(2),
      );
      expect(
        const Result<int, Failure>.success(3).flatMap(half),
        isA<Failed<int, Failure>>(),
      );
      expect(
        const Result<int, Failure>.failure(failure).flatMap(half),
        const Result<int, Failure>.failure(failure),
      );
    });

    test('mapFailure transforms failure only', () {
      final mapped = const Result<int, Failure>.failure(failure)
          .mapFailure((f) => UnexpectedFailure(message: f.message));
      expect(mapped.failureOrNull, isA<UnexpectedFailure>());
      expect(
        const Result<int, Failure>.success(1)
            .mapFailure((f) => const UnexpectedFailure())
            .valueOrNull,
        1,
      );
    });

    test('getOrElse falls back on failure', () {
      expect(const Result<int, Failure>.success(5).getOrElse((_) => 0), 5);
      expect(
        const Result<int, Failure>.failure(failure).getOrElse((_) => 0),
        0,
      );
    });

    test('onSuccess / onFailure fire on the right branch', () {
      var successCalls = 0;
      var failureCalls = 0;
      const success = Result<int, Failure>.success(1);
      const failed = Result<int, Failure>.failure(failure);
      success
        ..onSuccess((_) => successCalls++)
        ..onFailure((_) => failureCalls++);
      failed
        ..onSuccess((_) => successCalls++)
        ..onFailure((_) => failureCalls++);
      expect(successCalls, 1);
      expect(failureCalls, 1);
    });

    test('value equality', () {
      expect(
        const Result<int, Failure>.success(1),
        const Result<int, Failure>.success(1),
      );
      expect(
        const Result<int, Failure>.success(1),
        isNot(const Result<int, Failure>.success(2)),
      );
      expect(
        const Result<int, Failure>.failure(failure),
        const Result<int, Failure>.failure(failure),
      );
      expect(
        const Result<int, Failure>.failure(failure),
        isNot(const Result<int, Failure>.failure(CacheFailure())),
      );
      expect(
        const Result<int, Failure>.success(1),
        isNot(const Result<int, Failure>.failure(failure)),
      );
    });

    test('hashCode agrees with equality', () {
      expect(
        const Result<int, Failure>.success(1).hashCode,
        const Result<int, Failure>.success(1).hashCode,
      );
      expect(
        const Result<int, Failure>.failure(failure).hashCode,
        const Result<int, Failure>.failure(failure).hashCode,
      );
      // Success(x) and Failed(x) must not collide.
      expect(
        const Result<int, Failure>.success(1).hashCode,
        isNot(const Result<int, Failure>.failure(failure).hashCode),
      );
    });

    test('toString names the variant and payload', () {
      expect(const Result<int, Failure>.success(7).toString(), contains('7'));
      expect(
        const Result<int, Failure>.failure(failure).toString(),
        contains('NetworkFailure'),
      );
    });
  });
}
