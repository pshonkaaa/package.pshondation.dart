
@Deprecated('review')
class Range {
  static Range adjustToList(Range range, List list) {
    int start, end;
    if(range.start > list.length)
      start = list.length;
    else start = range.start;

    if(range.end == -1 || range.end > list.length)
      end = list.length;
    else end = range.end;
    return new Range(start, end);
  }


  final int start;
  final int end;
  final int length;
  
  const Range(int start, int? end, [int length = 0]) :
    this.start  = start,
    this.end    = end == null ? start + length : end,
    this.length = end == null ? length : end - start;



  Range operator +(int n) {
    int end = this.end + n;
    return new Range(this.start, end);
  }

  Range operator -(int n) {
    int start = this.start;
    int end = this.end - n;

    if(end < 0)
      end = 0;
    if(start > end)
      start = end;
    return new Range(start, end);
  }

  bool inRange(int index) => (start <= index && index <= end);

  @override
  String toString() => "Range($start, $end)";
}