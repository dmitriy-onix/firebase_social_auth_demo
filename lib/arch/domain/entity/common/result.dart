abstract class Result<T> {
  const Result();

  factory Result.ok(T data) => Ok<T>(data);

  factory Result.error({required Exception error}) => Error<T>(error);

  bool get isOk => this is Ok<T>;

  bool get isError => this is Error<T>;

  ///WARNING. ALWAYS CHECK success == true before call
  T get data => (this as Ok<T>).data;

  ///WARNING. ALWAYS CHECK isError == true before call
  Ok<T> get asOk => this as Ok<T>;

  ///WARNING. ALWAYS CHECK isError == true before call
  Error<T> get asError => this as Error<T>;

  B fold<B>(B Function(T ok) isOk, B Function(Error<T> err) isError);
}

final class Ok<T> extends Result<T> {
  final T _data;

  @override
  T get data => _data;

  Ok(T data) : _data = data;

  @override
  String toString() => 'Result<$T>.ok($_data)';

  @override
  B fold<B>(B Function(T ok) isOk, B Function(Error<T> err) isError) {
    return isOk(_data);
  }
}

final class Error<T> extends Result<T> {
  final Exception _error;

  Exception get error => _error;

  Error(Exception error) : _error = error;

  @override
  String toString() => 'Result<$T>.error($error)';

  @override
  B fold<B>(B Function(T ok) isOk, B Function(Error<T> err) isError) {
    return isError(asError);
  }
}
