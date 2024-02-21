import 'package:pshondation/library.dart';

import 'notifier_impl.dart';

class ProxyNotifierImpl<T, TSource> extends NotifierImpl<T> {
  static final TAG = (ProxyNotifierImpl).toString();

  final NotifierStorage _storage = new NotifierStorage();

  final Notifier<TSource> source;

  final NotifierConventer<TSource, T> getter;
  final NotifierConventer<T, TSource>? setter;

  final bool duplex;

  ProxyNotifierImpl(
    INotifier<TSource> source, {
      required this.getter,
      this.setter,
      bool execute = true,
      this.duplex = false,
  }) : source = source as Notifier<TSource>,
    super.empty() {
      
    if(duplex && setter == null)
      throw ArgumentError.notNull('setter');


    source.bind((v) {
      value_ = getter(v);
      notifyAll();
    }).addTo(_storage);
    
    if(execute) {
      T value = getter(source.value);
      value_ = value;
    }
  }

  @override
  set value(T v) {
    if(!duplex)
      throw Exception('duplex mode disabled');
    source.value = setter!(v);
  }

  @override
  void dispose() {
    _storage.dispose();
    super.dispose();
  }
}
