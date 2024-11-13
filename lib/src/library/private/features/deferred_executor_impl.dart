import 'dart:async';

import 'package:pshondation/library.dart';

class DeferredExecutorImpl<T> implements DeferredExecutor<T> {
  DeferredExecutorImpl();

  Completer<void>? _nextCompleter;
  FutureOrVoidCallback? _nextCallback;
  StackTrace? _nextStackTrace;

  Completer<void>? _currentCompleter;

  @override
  bool get isPending
    => _nextCallback != null;

  @override
  bool isExecuting = false;

  @override
  Future<void> get future
    => _currentCompleter?.future ?? Future.value();

  @override
  Future<void> get nextTaskFuture
    => _nextCompleter?.future ?? Future.value();
  
  @override
  void call(FutureOrVoidCallback callback) {
    if (!isPending) {
      _nextCompleter = Completer();
    }
    _nextCallback = callback;
    _nextStackTrace = StackTrace.current;
    
    _startExecution();
  }
  
  void _startExecution() {
    // Если задача уже выполняется - пропускаем.
    if (isExecuting) {
      return;
    }

    _preExecute();
  }

  void _preExecute() {
    isExecuting = true;
    
    _execute();
  }

  void _execute() {
    final completer = _currentCompleter = _nextCompleter!;
    final callback = _nextCallback!;
    final thisStackTrace = _nextStackTrace!;

    _nextCompleter = null;
    _nextCallback = null;
    _nextStackTrace = null;
    
    try {
      final result = callback();
      if (result is Future) {
        result.then((_) {
          _postExecute(completer);
        }).onError((Object error, StackTrace stackTrace) {
          _handleErrorAndContinue(completer, error, stackTrace, thisStackTrace);
        });
        
      } else {
        _postExecute(completer);
      }
    } catch(error, stackTrace) {
      _handleErrorAndContinue(completer, error, stackTrace, thisStackTrace);
    }
  }

  void _postExecute(Completer<void> completer) {
    completer.complete();
    
    if (_nextCallback != null) {
      _execute();
      return;
    }

    _currentCompleter = null;

    isExecuting = false;

    // IDIoT-PRoTECTIoN
    assertThrow(
      isExecuting == false &&
      _nextCallback == null &&
      _nextStackTrace == null &&
      _currentCompleter == null
    );
  }

  void _handleErrorAndContinue(
    Completer<void> completer,
    Object error,
    StackTrace stackTrace,
    StackTrace thisStackTrace,
  ) {
    scheduleMicrotask(() => _postExecute(completer));
    
    Error.throwWithStackTrace(CausedByException(error, stackTrace), thisStackTrace);
  }
}
