import 'package:true_core/src/core/features/Notifier/NotifierStorage.dart';
import 'package:true_core/src/core/features/Notifier/NotifierSubscription.dart';
import 'package:true_core/src/core/features/Notifier/typedef.dart';

abstract class INotifier<T> {
  T get value;

  int get length;

  bool get disposed;

  NotifierSubscription<T> bind(
    NotifierCallback<T> callback, {
      bool execute = false,
  });
  
  INotifier<T> unbind(NotifierCallback<T> callback);

  INotifier<T> addTo(NotifierStorage storage);

  Future<T> asFuture();
}