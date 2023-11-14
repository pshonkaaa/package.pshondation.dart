import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:synchronized/synchronized.dart';
import '../InputController.dart';

class FileInput extends InputController<Uint8List> {
  final String path;
  FileInput({
    required this.path,
  });

  @override
  bool connected = false;

  @override
  bool connecting = false;

  @override
  bool closed = true;

  @override
  int length = 0;

  @override
  int offset = 0;

  late File _file;
  late RandomAccessFile _fileStream;

  @override
  Future<bool> connect() async {
    if(connected)
      throw(Exception("Already connected"));
    if(connecting)
      throw(Exception("Already connecting"));
    connecting = true;

    _file = File(path);

    final exists = await _file.exists();
    if(!exists)
      _file = await _file.create(recursive: true);
    
    _fileStream = await _file.open(mode: FileMode.append);
    if(exists)
      length = await _fileStream.length();

    await _fileStream.setPosition(0);
    offset = 0;
    
    connected = true;
    connecting = false;
    closed = false;
    return true;
  }

  @override
  Future<bool> close() async {
    await _fileStream.close();
    connected = false;
    closed = true;
    return true;
  }

  @override
  Future<bool> setPosition(int offset) async {
    await _fileStream.setPosition(offset);
    this.offset = offset;
    return true;
  }

  @override
  Future<int> read(Uint8List buffer, [int? offset = 0, int? length = 0]) async {
    offset ??= 0;
    length ??= buffer.length - offset;

    final read = await _fileStream.readInto(buffer, offset, offset + length);
    this.offset = await _fileStream.position();
    this.length = await _fileStream.length();
    return read;
  }

  @override
  Future<int> readFrom(Uint8List buffer, int dstOffset, [int? offset, int? length]) async {
    offset ??= 0;
    length ??= buffer.length - offset;

    final tmp = this.offset;
    await _fileStream.setPosition(dstOffset);
    final read = await _fileStream.readInto(buffer, offset, offset + length);
    await _fileStream.setPosition(tmp);
    this.length = await _fileStream.length();
    return read;
  }

  @override
  Future<int> append(Uint8List buffer, [int? offset, int? length]) async {
    offset ??= 0;
    length ??= buffer.length - offset;

    await _fileStream.setPosition(this.length);
    await _fileStream.writeFrom(buffer, offset, offset + length);
    await _fileStream.setPosition(this.offset);
    this.length = await _fileStream.length();
    return length;
  }

  @override
  Future<int> write(Uint8List buffer, [int? offset, int? length]) async {
    offset ??= 0;
    length ??= buffer.length - offset;

    // this.length = await _fileStream.length();
    await _fileStream.writeFrom(buffer, offset, offset + length);
    this.offset = await _fileStream.position();
    this.length = await _fileStream.length();
    return length;
  }

  @override
  Future<int> writeTo(Uint8List buffer, int dstOffset, [int? offset, int? length]) async {
    offset ??= 0;
    length ??= buffer.length - offset;

    final tmp = this.offset;
    await _fileStream.setPosition(dstOffset);
    await _fileStream.writeFrom(buffer, offset, offset + length);
    await _fileStream.setPosition(tmp);
    this.length = await _fileStream.length();
    return length;
  }

  final Lock _lock = new Lock();

  @override
  FutureOr<T> synchronized<T>(FutureOr<T> Function() computation, {Duration? timeout}) async {
    return await _lock.synchronized(computation, timeout: timeout);
  }

}