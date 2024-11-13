import 'dart:async';

abstract class Disposable {
  bool get disposed;
  
  void dispose();
}

abstract class AsyncDisposable implements Disposable {
  @override
  bool get disposed;

  @override
  Future<void> dispose();
}