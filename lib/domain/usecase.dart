abstract class UseCase<Type, Params> {
  Future<Type> call(Params params, {
    required ResultErrorCallback onError,
  });
}

typedef ResultErrorCallback = void Function(Exception error);