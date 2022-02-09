import 'dart:async';

import 'NotifierSubscription.dart';
import 'typedef.dart';

class NotifierStorage {
  static final Map<Type, NotifierSubscriptionConverter> converters = {};
  
  final List<NotifierSubscription> _subscriptions = [];
  final List<StreamSubscription> _streamSubscriptions = [];
  final List<NotifierStorage> _storages = [];
  
  bool get disposed => _disposed;

  bool _disposed = false;

  void add(Object value) {
    _throwIfDisposed();
    _subscriptions.add(value is NotifierSubscription ? value : _convert(value));
  }

  static NotifierSubscription _convert(Object value) {
    final type = value.runtimeType;
    if(!converters.containsKey(type))
      throw(Exception("NotifierStorage doesnt support $type"));
    return converters[type]!(value);
  }

  void addStorage(NotifierStorage storage) {
    _throwIfDisposed();
    _storages.add(storage);
  }

  void addStream(StreamSubscription sub) {
    _throwIfDisposed();
    _streamSubscriptions.add(sub);
  }
  
  /// Cancel all subscriptions and clear list
  void clear() {
    _throwIfDisposed();
    for(var sub in _subscriptions)
      sub.cancel();
    _subscriptions.clear();

    for(var sub in _streamSubscriptions)
      sub.cancel();
    _streamSubscriptions.clear();

    _storages.clear();
  }

  /// Cancel all subscriptions and dispose list
  void dispose() {
    if(!_disposed) {
      clear();
      for(var storage in _storages)
        storage.dispose();
    } _disposed = true;
  }

  void _throwIfDisposed() {
    if(_disposed)
      throw(new Exception("NotifierStorage disposed"));
  }
}