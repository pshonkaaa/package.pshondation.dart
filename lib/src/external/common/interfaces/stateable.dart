import 'dart:async';

abstract class IStateable {
  bool get initialized;

  bool get disposed;

  void initState();

  void dispose();
}

abstract class IAsyncStateable implements IStateable {
  FutureOr<void> initState();
  
  FutureOr<void> dispose();
}