import 'dart:async';

import 'package:pshondation/library.dart';

abstract class IStateable implements IDisposable {
  bool get initialized;

  @override
  bool get disposed;

  void initState();
  
  @override
  void dispose();
}

abstract class IAsyncStateable implements IStateable, IAsyncDisposable {
  @override
  bool get initialized;

  @override
  bool get disposed;

  @override
  Future<void> initState();
  
  @override
  Future<void> dispose();
}