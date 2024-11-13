import 'dart:async';

import 'package:meta/meta.dart';
import 'package:pshondation/library.dart';

mixin DisposableMixin implements Disposable {
  @override
  bool get disposed => _disposed;
  
  bool _disposed = false;

  @override
  @mustCallSuper
  void dispose() {
    ensureNotDisposed();
    
    _disposed = true;
  }

  void ensureNotDisposed() {
    if (disposed) {
      throw ExceptionsKit.alreadyDisposed(this);
    }
  }
}

mixin AsyncDisposableMixin on DisposableMixin implements AsyncDisposable {
  @override
  Future<void> dispose() async {
    super.dispose();
  }
}