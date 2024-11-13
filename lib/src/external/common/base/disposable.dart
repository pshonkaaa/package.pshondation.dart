import 'dart:async';

import 'package:meta/meta.dart';
import 'package:pshondation/library.dart';

abstract class BaseDisposable implements IDisposable {
  @override
  bool get disposed => _disposed;
  
  bool _disposed = false;

  @override
  @mustCallSuper
  void dispose() {
    // TODO throw if already disposed
    _disposed = true;
  }

  // TODO ensure and not ensure

  void throwIfDisposed() {
    if (disposed) {
      throw Exception('$runtimeType has been disposed');
    }
  }
}

abstract class BaseAsyncDisposable extends BaseDisposable implements IAsyncDisposable {
  @override
  Future<void> dispose() async {
    super.dispose();
  }
}