

// @Deprecated("Need to review")
// class RenewableTimer implements Timer {
//   final Duration duration;
//   final void Function() _callback;
//   RenewableTimer(this.duration, this._callback) { _run(); }


//   void cancel() { _timer?.cancel(); }
//   void renew() { cancel(); _run(); }

//   Timer? _timer;
//   void _run() {
//     _timer = new Timer(duration, _callback);
//   }

//   @override
//   bool get isActive => _timer?.isActive ?? false;

//   @override
//   int get tick => _timer?.tick ?? 0;
// }