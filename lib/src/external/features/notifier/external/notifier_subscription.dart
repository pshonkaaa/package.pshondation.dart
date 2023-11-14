import 'notifier_storage.dart';

abstract class NotifierSubscription<T> {
  NotifierSubscription<T> addTo(NotifierStorage storage);
  NotifierSubscription<T> execute();
  void cancel();
}