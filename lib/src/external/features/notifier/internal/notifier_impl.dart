import 'dart:async';

import 'package:true_core/library.dart';

import 'notifier_subscription_impl.dart';

class NotifierImpl<T> implements Notifier<T> {  
  NotifierImpl({
    required T value,
  }) : value_ = value;

  NotifierImpl.empty();

  List<NotifierCallback<T>>? _listeners = [];
  late T value_;
  bool _skipping = false;

  @override
  T get value => value_;
  
  @override
  int get length => _listeners?.length ?? 0;

  @override
  bool get disposed => _listeners == null;

  @override
  NotifierSubscription<T> bind(
    NotifierCallback<T> callback, {
      bool execute = false,
  }) {
    _throwIfDisposed();

    _listeners!.add(callback);

    final sub = new NotifierSubscriptionImpl<T>(this, callback);

    if(execute)
      callback(value_);
    return sub;
  }
  
  @override
  Notifier<T> unbind(NotifierCallback<T> callback) {
    _throwIfDisposed();
    
    _listeners!.remove(callback);
    return this;
  }

  Notifier<T> addTo(NotifierStorage storage) {
    storage.addNotifier(this);
    return this;
  }

  @override
  Future<T> asFuture() {
    late final NotifierSubscription sub;
    final completer = new Completer<T>();
    sub = bind((value) {
      sub.cancel();
      completer.complete(value);
    });
    return completer.future;
  }









  // CONTROLLER
  //----------------------------------------------------------------------------

  @override
  set value(T v) {
    value_ = v;

    if(!_skipping) {
      notifyAll();
    } else _skipping = false;
  }

  @override
  bool get skipping => _skipping;

  @override
  void skipNotify() {
    _skipping = true;
  }

  @override
  void notifyAll() {
    for(final callback in _listeners!.toList())
      callback(value_);
  }

  @override
  void clear() {
    _listeners!.clear();
  }

  @override
  void dispose() {
    if(_listeners == null)
      return;
    clear();
    _listeners = null;
  }
  //----------------------------------------------------------------------------



  void _throwIfDisposed() {
    if(_listeners == null)
      throw new Exception("Notifier has been disposed");
  }
}