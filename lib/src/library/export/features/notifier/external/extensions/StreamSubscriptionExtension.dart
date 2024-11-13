import 'dart:async';

import 'package:pshondation/src/library/export/features/notifier/external/notifier_storage.dart';
import 'package:pshondation/src/library/export/features/notifier/external/notifier_subscription.dart';

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
  NotifierSubscription<T> execute() {
    throw(Exception("unrealized"));
  }

  @override
  void cancel() {
    subscription.cancel();
  }
}