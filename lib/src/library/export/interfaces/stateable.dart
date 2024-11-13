import 'dart:async';

import 'package:pshondation/library.dart';

abstract class Stateable implements Disposable {
  bool get initialized;

  @override
  bool get disposed;

  void initState();
  
  @override
  void dispose();
}

abstract class AsyncStateable implements Stateable, AsyncDisposable {
  @override
  bool get initialized;

  @override
  bool get disposed;

  @override
  Future<void> initState();
  
  @override
  Future<void> dispose();
}