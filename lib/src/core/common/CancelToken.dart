import 'dart:async';

class CancelToken {
  CancelToken();

  final Completer<void> _completer = Completer();

  /// Whether the token is cancelled.
  bool get isCancelled => _completer.isCompleted;
  
  void cancel() {
    if (!_completer.isCompleted) {
      _completer.complete();
    }
  }
}