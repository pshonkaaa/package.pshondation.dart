import 'dart:math';

class IndefiniteRange {
  const IndefiniteRange(int? start, int? end) :
    this.start  = start,
    this.end    = end;

  final int? start;
  
  final int? end;

  Range appendRange(
    Range range,
  ) => Range(
    start ?? range.start,
    end ?? range.end,
  );

  @override
  String toString() => "IndefiniteRange($start, $end)";  
}

class Range {
  @Deprecated('review')
  static Range adjustToList(Range range, List list) {
    int start, end;
    if(range.start > list.length)
      start = list.length;
    else start = range.start;

    if(range.end == -1 || range.end > list.length)
      end = list.length;
    else end = range.end;
    return Range(start, end);
  }

  /// **Warning**: input is sorted list
  static Range extractFrom(Iterable<int> sortedList) {
    final vMin = sortedList.reduce(min);
    final vMax = sortedList.reduce(max);
    return Range(vMin, vMax);
  }

  /// **Warning**: input is sorted list
  static List<Range> findMissingRanges(Iterable<int> sortedList, [int? start, int? end]) {
    final List<Range> missingRanges = [];

    start ??= sortedList.first;
    end ??= sortedList.last;

    final it = sortedList.iterator;
    
    int prev = start - 1;
    for (int i = 0; i < sortedList.length; i++) {
      it.moveNext();
      
      int curr = it.current;
      
      if (curr - prev > 1) {
        missingRanges.add(Range(prev + 1, curr - 1));
      }
      
      prev = curr;
    }

    // Check for missing elements at the end of the range
    if (end - prev > 0) {
      missingRanges.add(Range(prev + 1, end));
    }
    
    return missingRanges;
  }
  
  const Range(int start, int? end, [int length = 0]) :
    this.start  = start,
    this.end    = end == null ? start + length : end,
    this.length = end == null ? length : end - start;
  
  const Range.end(int end, int length) :
    this(end - length, end, length);

  final int start;
  
  final int end;

  final int length;


  Range operator +(int n) {
    int end = this.end + n;
    return Range(this.start, end);
  }

  Range operator -(int n) {
    int start = this.start;
    int end = this.end - n;

    if(end < 0)
      end = 0;
    if(start > end)
      start = end;
    return Range(start, end);
  }

  Range append({
    int? start,
    int? end,
    int? length,
  }) => Range(
    start ?? this.start,
    end ?? (length == null ? this.end : null),
    length ?? this.length,
  );

  bool inRange(int index)
    => (start <= index && index <= end);

  @override
  String toString() => "Range($start, $end)";
}