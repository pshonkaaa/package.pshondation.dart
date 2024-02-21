import 'package:foundation/src/external/features/notifier/external/interfaces/notifier_sink.dart';
import 'package:foundation/src/external/features/notifier/external/typedef.dart';

import '../internal/notifier_impl.dart';
import '../internal/notifier_subscription_impl.dart';
import '../internal/proxy_notifier_impl.dart';
import 'interfaces/notifier.dart';

abstract class Notifier<T> implements INotifierSink<T> {
  factory Notifier({
    required T value,
  }) = NotifierImpl;

  factory Notifier.empty(

  ) = NotifierImpl.empty;

  static ProxyNotifierImpl<T, TSource> proxy<T, TSource>(
    INotifier<TSource> source, {
      required NotifierConventer<TSource, T> getter,
      NotifierConventer<T, TSource>? setter,
      bool execute = true,
      bool duplex = false,
  }) {
    return ProxyNotifierImpl<T, TSource>(
      source,
      getter: getter,
      setter: setter,
      execute: execute,
      duplex: duplex,
    );
  }

  static ProxyNotifierSubscription<T> proxyFromTo<T>(
    INotifier<T> src,
    Notifier<T> dst, {
      NotifierConventer? fSink,
      bool execute = true,
  }) {
    return ProxyNotifierSubscription(
      src,
      dst,
      fromSink: fSink,
      execute: execute,
    );
  }
}