sealed class Result<T> {
  final T? data;
  final Exception? error;

  Result._({this.data, this.error});

  factory Result.success(T data) = ResultSuccess;

  factory Result.error(Exception error) = ResultError;

  bool get succeeded => this is ResultSuccess && data != null;
}

final class ResultSuccess<T> extends Result<T> {
  ResultSuccess(T data) : super._(data: data);
}

final class ResultError<T> extends Result<T> {
  ResultError(Exception error) : super._(data: null, error: error);
}

Future<Result<T>> executeSafe<T>(Future<T> Function() operation) async {
  try {
    T result = await operation();
    return Result.success(result);
  } on Exception catch (error) {
    return Result.error(error);
  }
}
