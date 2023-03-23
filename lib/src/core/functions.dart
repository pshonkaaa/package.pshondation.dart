void throwIf(bool flag, [Object? error]) {
  if(flag)
    throw error ?? "Unknown exception";
}


typedef Predicate<T> = bool Function(T value);

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