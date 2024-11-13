import 'dart:async';

typedef ErrorCallback = void Function(Object error, StackTrace stackTrace);
typedef VoidCallback = void Function();
typedef ValueCallback<T> = void Function(T value);
typedef FutureCallback<T> = Future<T> Function();
typedef FutureVoidCallback = FutureCallback<void>;
typedef FutureOrCallback<T> = FutureOr<T> Function();
typedef FutureOrVoidCallback = FutureOrCallback<void>;

typedef GetterFunction<T> = T Function();
typedef SetterFunction<T> = void Function(T newValue);
typedef StreamOnDataCallback<T> = ValueCallback<T>;