extension IterableListExtension<T> on Iterable<Iterable<T>?> {
  List<T> combine() {
    final List<T> result = [];
    for(final item in this) {
      if(item != null)
        result.addAll(item);
    } return result;
  }

  List<T>? combineNull() {
    List<T>? result;
    for(final item in this) {
      if(item != null) {
        if(result == null)
          result = [];
          result.addAll(item);
      }
    } return result;
  }
}