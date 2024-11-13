abstract class BaseRange<T extends Comparable> {
  
  const BaseRange(
    this.start,
    this.end,
    this.length,
  );

  final T start;
  
  final T end;

  final int length;


  BaseRange operator +(int count);

  BaseRange operator -(int count);

  BaseRange append({
    T? start,
    T? end,
    int? length,
  });

  bool inRange(T index)
    => start.compareTo(index) <= 0 && index.compareTo(end) <= 0;

  @override
  String toString() => "$runtimeType($start, $end)";
}