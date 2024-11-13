import 'dart:async';

import 'package:meta/meta.dart';
import 'package:pshondation/library.dart';
import 'package:pshondation/library_impl.dart';

abstract class BaseStateable extends BaseDisposable implements Stateable {
  @override
  bool get initialized => _initialized;

  bool _initialized = false;

  @override
  @mustCallSuper
  void initState() {
    ensureNotInitialized();
    
    _initialized = true;
  }

  @override
  @mustCallSuper
  void dispose() {
    ensureInitialized();
    
    super.dispose();
    
    _initialized = false;
  }

  void ensureNotInitialized() {
    if (initialized) {
      throw ExceptionsKit.alreadyInitialized(this);
    }
  }

  void ensureInitialized() {
    if (!initialized) {
      throw ExceptionsKit.notInitialized(this);
    }
  }
}

abstract class BaseAsyncStateable extends BaseStateable implements AsyncStateable {
  @override
  Future<void> initState() async {
    super.initState();
  }
  
  @override
  Future<void> dispose() async {
    super.dispose();
  }
}