import 'package:true_core/src/core/features/Notifier/INotifier.dart';

abstract class INotifierSink<T> extends INotifier<T> {
  set value(T value);

  int get length;

  void clear();

  void dispose();
}