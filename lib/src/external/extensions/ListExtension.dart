extension ListExtension<E> on List<E> {
  // void retain(E e) {
  //   retainWhere((value) => value == e);
  // }

  void removeAll(Iterable<E> iterable) {
    for(final item in iterable) {
      remove(item);
    }
  }
}