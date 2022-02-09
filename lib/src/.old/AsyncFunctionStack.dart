// import 'dart:async';

// class AsyncFunctionStack {
//   final List<Function> _stack = [];
//   Completer<void>? _completer;
//   int _runningSize = 0;

//   bool get started => _completer != null;

//   void add(Function func, [bool execute = false]) {
//     _stack.add(func);
//     if(execute)
//       start();
//   }

//   Future<void> start() async {
//     if(started)
//       return;
//     if(_stack.length == 0)
//       return;

//     _completer = new Completer();
//     while(_stack.length > 0) {
//       final func = _stack.removeAt(0);
//       _runningSize++;
//       Future(() async {
//         try {
//           await func();
//         } catch(e, s) {
//           //TODO test
//           print("ERROR ASyncFunctionStack");
//           print(e);
//           print(s);
//           _completer.completeError(e,s);
//         } finally {
//           _runningSize--;
//         } _onPostFunc();
//       });
//     } await _completer!.future;
//   }

//   void _onPostFunc() {
//     if(_runningSize == 0 && _stack.length == 0 && !_completer.isCompleted)
//       _completer.complete();
//   }

//   Future<void> waitForComplete() {
//     if(_runningSize == 0 && _stack.length == 0 && !_completer.isCompleted)
//       _completer.complete();
//     return _completer.future;
//   }

// }