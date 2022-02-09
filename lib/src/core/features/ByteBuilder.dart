import 'dart:typed_data';

class ByteBuilder {
  Uint8List _buffer = Uint8List(0);
  final List<Uint8List> _chunks = [];
  int _length = 0;
  ByteBuilder();


  int get length => _buffer.length + _length;
  ByteData get byteData {
    if(_chunks.isNotEmpty)
      throw(new Exception("You should build() before use byteData"));
    return ByteData.view(_buffer.buffer);
  }

  void add(Uint8List data, [int offset = 0, int length = 0]) {
    if(length == 0)
      length = data.length - offset;
      
    if(length == 0)
      return;
    
    _length += data.length;
    _chunks.add(Uint8List.fromList(data.getRange(offset, offset + length).toList()));
  }

  Uint8List build() {
    if(_chunks.isEmpty)
      return _buffer;
    
    Uint8List temp = _buffer;

    _buffer = Uint8List(length);

    int offset = 0;

    for(final byte in temp)
      _buffer[offset++] = byte;

    for(final chunk in _chunks) {
      for(final byte in chunk)
        _buffer[offset++] = byte;
    } _length = 0;
    _chunks.clear();
    return _buffer;
  }
}