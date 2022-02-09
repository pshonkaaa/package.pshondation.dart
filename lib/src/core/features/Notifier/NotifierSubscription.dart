import 'INotifier.dart';
import 'Notifier.dart';
import 'NotifierStorage.dart';
import 'typedef.dart';

abstract class NotifierSubscription<T> {
  NotifierSubscription<T> addTo(NotifierStorage storage);
  NotifierSubscription<T> execute();
  void cancel();
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