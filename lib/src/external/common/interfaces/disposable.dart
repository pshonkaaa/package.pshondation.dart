import 'dart:async';

abstract class IDisposable {
  bool get disposed;
  
  void dispose();
}

abstract class IAsyncDisposable implements IDisposable {
  FutureOr<void> dispose();
}