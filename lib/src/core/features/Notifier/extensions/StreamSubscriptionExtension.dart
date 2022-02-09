import 'dart:async';

import 'package:true_core/src/core/features/Notifier/NotifierStorage.dart';
import 'package:true_core/src/core/features/Notifier/NotifierSubscription.dart';

extension StreamSubscriptionExtension on StreamSubscription {
  void addTo(NotifierStorage storage) {
    storage.add(_NotifierSubscriptionStream(
      subscription: this,
    ));
  }
}

class _NotifierSubscriptionStream<T> implements NotifierSubscription<T> {
  final StreamSubscription<T> subscription;
  _NotifierSubscriptionStream({
    required this.subscription,
  });

  @override
  NotifierSubscription<T> addTo(NotifierStorage storage) {
    storage.add(this);
    return this;    
  }

  @override
  void cancel() {
    subscription.cancel();
  }
}