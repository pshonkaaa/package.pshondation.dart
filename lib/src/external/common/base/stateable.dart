import 'dart:async';

import 'package:meta/meta.dart';
import 'package:pshondation/library.dart';

abstract class BaseStateable extends BaseDisposable implements IStateable {
  @override
  bool get initialized => _initialized;

  bool _initialized = false;

  @override
  @mustCallSuper
  void initState() {
    // TODO throw if already initialized
    _initialized = true;
  }

  @override
  @mustCallSuper
  void dispose() {
    super.dispose();
    _initialized = false;
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