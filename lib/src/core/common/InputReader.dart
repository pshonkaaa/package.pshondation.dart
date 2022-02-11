abstract class InputReader<T extends List> {
  /// Read into buffer with [offset] and [length] if present
  /// 
  /// Returns read length
  Future<int> read(T buffer, [int? offset, int? length]);

  /// Read into buffer with [offset] and [length]
  /// from [dstOffset]
  /// 
  /// Returns read length
  Future<int> readFrom(T buffer, int dstOffset, [int? offset, int? length]);
}