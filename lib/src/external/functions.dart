import 'dart:async';

import 'package:pshondation/library.dart';
import 'package:pshondation/src/external/common/cancel_token.dart';

@deprecated
void throwIf(bool flag, [Object? error]) 
  => conditionThrow(flag, error);

void assertThrow(bool flag, [Object? error]) {
  if(!flag)
    throw error ?? Exception('Unknown exception');
}

void conditionThrow(bool flag, [Object? error]) {
  if(flag)
    throw error ?? Exception('Unknown exception');
}


typedef Predicate<T> = bool Function(T value);
typedef Test = bool Function();

Future<bool> waitUntil({
  required FutureOr<bool> Function() test,
  Duration delay = const Duration(milliseconds: 10),
  required Duration timeout,
  bool throwException = true,
  CancelToken? cancelToken,
}) {
  final stackTrace = StackTrace.current;
  final completer = Completer<bool>();
  
  final timer = Timer(
    timeout, () {
      if(completer.isCompleted)
        return;
      
      if(throwException)
        completer.completeError(TimeoutException(null, timeout), stackTrace);
      else completer.complete(false);
  });
  
  Future(() async {
    while(true) {
      if(cancelToken?.isCancelled ?? false) {
        completer.completeError(CanceledException(), stackTrace);
        break;
      }

      if(completer.isCompleted)
        break;
        
      if((await test()) == false) {
        completer.complete(true);
        break;
      } await Future.delayed(delay);
    }

    timer.cancel();
  });
  return completer.future;
}

Future<T> tryExecuteSeveralTimes<T>({
  required Future<T> callback(),
  required int times,
  required Duration delay,
  Predicate<T>? predicate,
  bool absorbException = false,
}) async {
  if(times == 0)
    throw("times == 0");
  
  T? result;
  bool first = true;
  bool last;

  int i = 0;
  do {
      last = i + 1 == times;
      if(!first) {
          await Future.delayed(delay);
      } else first = false;

      if(absorbException && !last) {
          try {
              result = await callback();
          } catch(e) { continue; }
      } else result = await callback();

      if(predicate == null) {
          if((T == bool && result == false) || result == null)
              continue;
      } else {
          if(!predicate(result!))
              continue;
      } break;
  } while(i++ < times);
  return result as T;
}