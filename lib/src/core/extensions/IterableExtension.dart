typedef CompareFunction<E> = bool Function(E e1, E e2);

extension IterableExtension<E> on Iterable<E> {
  E? get tryFirst {
    Iterator<E> it = iterator;
    return it.moveNext() == false ? null : it.current;
  }

  E? get tryLast {
    Iterator<E> it = iterator;
    if (!it.moveNext())
      return null;
    E result;
    do {
      result = it.current;
    } while (it.moveNext());
    return result;
  }

  bool containsList(Iterable<E> iterable, [bool wholeList = false]) {
    if(!wholeList) {
      final it = iterator;
      E item;
      while (it.moveNext()) {
        item = it.current;
        if(contains(item))
          return true;
      } return false;
    } else {
      final it = iterator;
      E item;
      while (it.moveNext()) {
        item = it.current;
        if(contains(item))
          return false;
      } return true;
    }
  }

  @Deprecated("review!")
  Map<K, List<E>> group<K>(K callback(E e)) {
    final Map<K, List<E>> map = {};
    
    final it = iterator;
    E e;
    while (it.moveNext()) {
      e = it.current;

      final key = callback(e);
      if(!map.containsKey(key))
        map[key] = [];
      map[key]!.add(e);
    } return map;
  }

  List<E> filter([CompareFunction<E>? compare]) {
    final List<E> list = [];
    
    if(compare != null) {
      for(final item in this) {
        if(list.tryFirstWhere((e) => compare(e, item)) == null) {
          list.add(item);
        }
      }
    } else {
      for(final item in this) {
        if(list.tryFirstWhere((e) => e == item) == null) {
          list.add(item);
        }
      }
    } return list;
  }

  Iterable<E> removeNull() {
    return where((e) => e != null);
  }

  E? tryElementAt(int index) {
    RangeError.checkNotNegative(index, "index");
    if(index >= length)
      return null;
    return elementAt(index);
  }

  E? tryFirstWhere(bool Function(E e) test) {
    try { return firstWhere(test); } on StateError { return null; }
  }

  E? tryLastWhere(bool Function(E e) test) {
    try { return lastWhere(test); } on StateError { return null; }
  }

  E? trySingleWhere(bool Function(E e) test) {
    try { return singleWhere(test); } on StateError { return null; }
  }
}