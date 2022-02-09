import 'dart:async';

import 'package:true_core/src/core/features/Notifier/INotifierSink.dart';
import 'package:true_core/src/core/features/Notifier/typedef.dart';

import 'INotifier.dart';
import 'NotifierStorage.dart';
import 'NotifierSubscription.dart';

class Notifier<T> extends INotifierSink<T> {
  static SubscribedNotifier<T, IN> subscribeTo<T, IN>(
    INotifier<IN> origin, {
      NotifierConventer<T, IN>? toSink,
      required NotifierConventer<IN, T> fromSink,
      bool execute = true,
      bool transferOnSet = true,
  }) {
    return new SubscribedNotifier<T, IN>(
      origin,
      toSink: toSink,
      fromSink: fromSink,
      execute: execute,
      transferOnSet: transferOnSet,
    );
  }

  static ProxyNotifierSubscription<T> proxy<T>(
    INotifier<T>  src,
    Notifier<T>   dst, {
      NotifierConventer? fSink,
      bool execute = true,
  }) {
    return new ProxyNotifierSubscription(
      src,
      dst,
      fromSink: fSink,
      execute: execute,
    );
  }


  
  List<NotifierCallback<T>>? _listeners = [];
  late T _value;
  Notifier({
    T? value,
  }) {
    if(value != null)
      _value = value;
  }

  // SINK
  //----------------------------------------------------------------------------
  @override
  NotifierSubscription<T> bind(
    NotifierCallback<T> callback, {
      bool execute = false,
  }) {
    _throwIfDisposed();

    _listeners!.add(callback);

    final sub = new _NotifierSubscription<T>(this, callback);

    if(execute)
      callback(_value);
    return sub;
  }
  
  @override
  INotifierSink<T> unbind(NotifierCallback<T> callback) {
    _throwIfDisposed();
    
    _listeners!.remove(callback);
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

  @override
  T get value => _value;
  //----------------------------------------------------------------------------









  // CONTROLLER
  //----------------------------------------------------------------------------  
  @override
  int get length => _listeners?.length ?? 0;

  @override
  set value(T v) {
    _value = v;
    notifyAll();
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

  void notifyAll() {
    for(var f in _listeners!.toList())
      f.call(_value);
  }
  //----------------------------------------------------------------------------



  void _throwIfDisposed() {
    if(_listeners == null)
      throw new Exception("Notifier has been disposed");
  }
}



class SubscribedNotifier<T, TSOURCE> extends Notifier<T> {
  final NotifierStorage _storage = new NotifierStorage();

  final INotifier<TSOURCE> source;

  late final Notifier<TSOURCE> _notifier;
  late final NotifierConventer<T, TSOURCE> _toSink;
  late final NotifierConventer<TSOURCE, T> _fromSink;

  SubscribedNotifier(
    this.source, {
      NotifierConventer<T, TSOURCE>? toSink,
      required NotifierConventer<TSOURCE, T> fromSink,
      bool execute = true,
      bool transferOnSet = true,
  }) {
    _notifier = source as Notifier<TSOURCE>;
    _toSink = toSink ?? _defaultOnSet();
    _fromSink = fromSink;


    _notifier.bind((v) {
      _value = _fromSink.call(v);
      notifyAll();
    }).addTo(_storage);

    _value = fromSink(source.value);

    if(execute) {
      T value = _fromSink(_notifier._value);
      _value = value;
    }
  }

  @override
  set value(T v) {
    _notifier.value = _toSink(v);
  }

  @override
  void dispose() {
    if(_listeners!.length > 0)
      throw(new Exception("_listeners.length > 0"));
    _storage.clear();
    _listeners = null;
  }

  static NotifierConventer<T, TSOURCE> _defaultOnSet<T, TSOURCE>() {
    throw(new Exception("notifier.set(T value); Not realized"));
  }
}


class _NotifierSubscription<T> extends NotifierSubscription<T> {
  NotifierCallback<T>? callback;
  final INotifier<T> notifier;
  _NotifierSubscription(this.notifier, this.callback);

  @override
  NotifierSubscription<T> addTo(NotifierStorage storage) {
    storage.add(this);
    return this;
  }

  @override
  void cancel() {
    if(callback != null) {
      notifier.unbind(callback!);
      callback = null;
    }
  }

}