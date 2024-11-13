import 'package:pshondation/src/export/features/notifier/external/notifier_storage.dart';
import 'package:pshondation/src/export/features/notifier/external/notifier_subscription.dart';
import 'package:pshondation/src/export/features/notifier/external/typedef.dart';

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