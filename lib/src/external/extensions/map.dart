extension MapExtension<K, V> on Map<K, V> {
  // List<K> getCommonKeysWith(Map<K, V> other) {
  //   final List<K> result = [];
  //   for (final key in keys) {
  //     if (other.containsKey(key)) {
  //       result.add(key);
  //     }
  //   }
  //   return result;
  // }

  List<K> getPresentKeysWith(Map<K, dynamic> other) {
    final List<K> result = [];
    for (final key in keys) {
      if (other.containsKey(key)) {
        result.add(key);
      }
    }
    return result;
  }

  List<K> getMissingKeysWith(Map<K, dynamic> other) {
    final List<K> result = [];
    for (final key in other.keys) {
      if (!containsKey(key)) {
        result.add(key);
      }
    }
    return result;
  }

  void removeKeys(Iterable<K> iterable) {
    for(final item in iterable) {
      remove(item);
    }
  }
}