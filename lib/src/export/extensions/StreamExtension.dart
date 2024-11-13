extension StreamExtension<T> on Stream<T> {
  Future<List<T>> asFuture() async {
    final List<T> list = [];
    await this.listen((event) {
      list.add(event);
    }).asFuture();
    return list;
  }
}