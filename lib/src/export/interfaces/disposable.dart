import 'dart:async';

abstract class IDisposable {
  bool get disposed;
  
  void dispose();
}

abstract class IAsyncDisposable implements IDisposable {
  @override
  bool get disposed;

  @override
  Future<void> dispose();
}