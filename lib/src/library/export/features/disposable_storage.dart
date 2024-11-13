import 'dart:async';

import 'package:pshondation/library.dart';

/// TODO review
class DisposableStorage with DisposableMixin {  
  final List<Disposable> _disposes = [];
  final List<DisposableStorage> _storages = [];
  
  @override
  bool get disposed;

  void add(Disposable object) {
    ensureNotDisposed();

    _disposes.add(object);
  }

  void addStorage(DisposableStorage object) {
    ensureNotDisposed();

    _storages.add(object);
  }
  
  /// Disposes everything and clear list
  void clean() {
    ensureNotDisposed();
    
    for(final object in _disposes) {
      object.dispose();
    } _disposes.clear();


    for(final object in _storages) {
      object.dispose();
    } _storages.clear();
  }

  @override
  /// Disposes everything
  void dispose() {
    ensureNotDisposed();
    
    clean();

    super.dispose();
  }
}