import 'dart:typed_data';

import 'ByteBuilder.dart';

class BufferPointer {
  final ByteBuilder _builder = new ByteBuilder();

  BufferPointer(
    Uint8List buffer, [int offset = 0, int length = 0]
  ) { _builder.add(buffer, offset, length); }
  BufferPointer.empty();
  
  Uint8List get buffer => _builder.build();
  ByteData  get _byteData => _builder.byteData;

  int   get offset    => _offset;
  int   get length    => buffer.length;
  int   get remaining => buffer.length - _offset;


  int _offset = 0;

  void reset() => _offset = 0;

  bool flip(int length)  {
    if(_offset - length < 0)
      return false;
    _offset -= length;
    return true;
  }

  bool skip(int length)  {
    if(_offset + length > buffer.length)
      return false;
    _offset += length;
    return true;
  }

  // GETTERS
  //----------------------------------------------------------------------------
  int? getByte() {
    if(_offset + 1 > buffer.length)
      return null;
    return buffer[_offset++];
  }

  Uint8List? getBytes(int len) {
    if(_offset + len > buffer.length)
      return null;
    final out = Uint8List(len);
    for(int i = 0; i < len; i++) {
      out[i] = buffer[_offset + i];
    } _offset += len;
    return out;
  }

  String? getString(int len) {
    if(_offset + len > buffer.length)
      return null;
    return new String.fromCharCodes(buffer.getRange(_offset, _offset + len));
  }

  int? getInt16() {
    if(_offset + 2 > buffer.length)
      return null;
    final out = _byteData.getInt16(_offset);
    _offset += 2;
    return out;
  }

  int? getUint16() {
    if(_offset + 2 > buffer.length)
      return null;
    final out = _byteData.getUint16(_offset);
    _offset += 2;
    return out;
  }

  int? getInt32() {
    if(_offset + 4 > buffer.length)
      return null;
    final out = _byteData.getInt32(_offset);
    _offset += 4;
    return out;
  }

  int? getUint32() {
    if(_offset + 4 > buffer.length)
      return null;
    final out = _byteData.getUint32(_offset);
    _offset += 4;
    return out;
  }

  int? getInt64() {
    if(_offset + 8 > buffer.length)
      return null;
    final out = _byteData.getInt64(_offset);
    _offset += 8;
    return out;
  }

  int? getUint64() {
    if(_offset + 8 > buffer.length)
      return null;
    final out = _byteData.getUint64(_offset);
    _offset += 8;
    return out;
  }
  //----------------------------------------------------------------------------


  // SETTERS
  //----------------------------------------------------------------------------
  void pushByte(int value) {
    _builder.add(Uint8List(1)..[0] = value);
  }

  void pushBytes(Uint8List value, [int offset = 0, int? length]) {
    if(length != null)
      value = Uint8List.fromList(value.getRange(offset, offset + length).toList());
    _builder.add(value);
  }

  void pushString(String value) {
    _builder.add(Uint8List.fromList(value.codeUnits));
  }

  void pushInt16(int value) {
    final data = ByteData(2)..setInt16(0, value);
    _builder.add(data.buffer.asUint8List());
  }

  void pushUInt16(int value) {
    final data = ByteData(2)..setUint16(0, value);
    _builder.add(data.buffer.asUint8List());
  }

  void pushInt32(int value) {
    final data = ByteData(4)..setInt32(0, value);
    _builder.add(data.buffer.asUint8List());
  }

  void pushUInt32(int value) {
    final data = ByteData(4)..setUint32(0, value);
    _builder.add(data.buffer.asUint8List());
  }

  void pushInt64(int value) {
    final data = ByteData(8)..setInt64(0, value);
    _builder.add(data.buffer.asUint8List());
  }

  void pushUInt64(int value) {
    final data = ByteData(8)..setUint64(0, value);
    _builder.add(data.buffer.asUint8List());
  }
  //----------------------------------------------------------------------------


  Uint8List build() => _builder.build();
  String stringify() => buffer.isEmpty ? "Buffer is empty" : String.fromCharCodes(buffer);
}
