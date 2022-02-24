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