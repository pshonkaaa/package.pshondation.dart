import 'dart:async';

import 'package:meta/meta.dart';
import 'package:true_core/library.dart';

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
  FutureOr<void> initState() {
    super.initState();
  }
  
  @override
  FutureOr<void> dispose() {
    super.dispose();
  }
}