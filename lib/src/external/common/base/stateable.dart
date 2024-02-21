import 'dart:async';

import 'package:meta/meta.dart';
import 'package:foundation/library.dart';

abstract class BaseStateable implements IStateable {
  @override
  bool get initialized => _initialized;

  @override
  bool get disposed => _disposed;

  bool _initialized = false;
  
  bool _disposed = false;

  @override
  @mustCallSuper
  void initState() {
    // TODO throw if already init
    _initialized = true;
    _disposed = false;
  }

  @override
  @mustCallSuper
  void dispose() {
    _initialized = false;
    _disposed = true;
  }
}

abstract class BaseAsyncStateable extends BaseStateable implements IAsyncStateable {
  @override
  Future<void> initState() async {
    super.initState();
  }
  
  @override
  Future<void> dispose() async {
    super.dispose();
  }
}