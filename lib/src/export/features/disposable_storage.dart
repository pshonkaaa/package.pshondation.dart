import 'dart:async';

import 'package:pshondation/library.dart';

/// TODO review
class DisposableStorage extends BaseDisposable {  
  final List<IDisposable> _disposes = [];
  final List<DisposableStorage> _storages = [];
  
  @override
  bool get disposed;

  void add(IDisposable object) {
    _throwIfDisposed();
    _disposes.add(object);
  }

  void addStorage(DisposableStorage object) {
    _throwIfDisposed();
    _storages.add(object);
  }
  
  /// Disposes everything and clear list
  void clean() {
    _throwIfDisposed();
    
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
    clean();

    super.dispose();
  }

  void _throwIfDisposed() {
    if(disposed)
      throw(Exception("DisposableStorage disposed"));
  }
}