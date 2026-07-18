import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/result/result.dart';

/// Base contract for domain use cases. Presentation depends on these,
/// never on repositories directly.
// ignore: one_member_abstracts
abstract interface class UseCase<Input, Output> {
  Future<Result<Output, Failure>> call(Input input);
}

/// Base contract for use cases that expose a reactive read model (e.g. a
/// Drift-backed cache). The stream carries `Result`s so failures cross the
/// boundary as values, exactly like the Future-based [UseCase].
// ignore: one_member_abstracts
abstract interface class StreamUseCase<Input, Output> {
  Stream<Result<Output, Failure>> call(Input input);
}

/// Input for use cases that take no arguments.
class NoParams {
  const NoParams();
}
