import 'package:true_core/library.dart';

class NotifierSubscriptionImpl<T> extends NotifierSubscription<T> {
  NotifierCallback<T>? callback;
  final INotifier<T> notifier;
  NotifierSubscriptionImpl(this.notifier, this.callback);

  @override
  NotifierSubscription<T> addTo(NotifierStorage storage) {
    storage.add(this);
    return this;
  }

  @override
  NotifierSubscription<T> execute() {
    callback!(notifier.value);
    return this;
  }

  @override
  void cancel() {
    if(callback != null && !notifier.disposed) {
      notifier.unbind(callback!);
      callback = null;
    }
  }
}

class ProxyNotifierSubscription<T> extends NotifierSubscription<T> {
  final INotifier<T>  _src;
  final Notifier<T>   _dst;
  final NotifierStorage _storage = new NotifierStorage();
  final NotifierConventer? fromSink;

  ProxyNotifierSubscription(
    this._src,
    this._dst, {
      this.fromSink,
      bool execute = true,
  }) {
    _src.bind(_onNotify).addTo(_storage);

    if(execute) {
      _dst.value = fromSink == null ? _src.value : fromSink!(_src.value);
    }
  }

  @override
  NotifierSubscription<T> addTo(NotifierStorage storage) {
    storage.add(this);
    return this;
  }

  @override
  NotifierSubscription<T> execute() {
    _dst.value = fromSink == null ? _src.value : fromSink!(_src.value);
    return this;
  }


  @override
  void cancel() {
    if(!_storage.disposed) {
      _storage.dispose();
    }
  }

  void _onNotify(T value) {
    T result;
    if(fromSink != null)
      result = fromSink!(value);
    else result = value;
    _dst.value = result;
  }
}

