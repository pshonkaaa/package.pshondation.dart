import 'package:true_core/src/core/features/Notifier/NotifierSubscription.dart';
import 'package:true_core/src/core/features/Notifier/typedef.dart';

abstract class INotifier<T> {
  T get value;

  int get length;

  NotifierSubscription<T> bind(
    NotifierCallback<T> callback, {
      bool execute = false,
  });
  
  INotifier<T> unbind(NotifierCallback<T> callback);

  Future<T> asFuture();
}