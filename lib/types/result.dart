import 'package:meta/meta.dart';

/// Base Result class
/// [T] represents the type of the success value
/// [String] represents the error message to be displayed
/// on the presentation layer

@immutable
sealed class Result<T, String> {
  const Result();
}

final class Success<T, String> extends Result<T, String> {
  const Success(this.value);
  final T value;
}

final class Failure<T, String> extends Result<T, String> {
  const Failure(this.errorMessage);
  final String errorMessage;
}
