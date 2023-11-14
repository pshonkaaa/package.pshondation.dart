import 'dart:async';

@deprecated
class SyncFunctionStack {
  bool get started => _completer != null;



  final List<Function> _stack = [];
  Completer<void>? _completer;

  void add(Function func, [bool execute = false]) {
    _stack.add(func);
    if(execute)
      start();
  }

  Future<void> start() async {
    if(started)
      return;
    if(_stack.length == 0)
      return;

    _completer = new Completer();
    while(_stack.length > 0) {
      final func = _stack.removeLast();
      try {
        await func();
      } catch(e, s) {
        _completer!.completeError(e,s);
        break;
      }
    } _completer!.complete();
    await _completer!.future;
  }

  Future<void> waitForComplete() {
    if(!started)
      return Future.value();
    return _completer!.future;
  }

}