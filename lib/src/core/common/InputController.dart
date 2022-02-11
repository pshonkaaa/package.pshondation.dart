import 'dart:async';

import 'InputReader.dart';
import 'InputWriter.dart';

abstract class InputController<T extends List> implements InputReader<T>, InputWriter<T> {

  bool get connected;

  bool get connecting;
  
  bool get closed;

  /// Length of input(i.e. file)
  int get length;

  int get offset;
  
  /// Connects to input
  /// 
  /// Return true if successful
  Future<bool> connect();

  Future<bool> close();

  Future<bool> setPosition(int offset);

  FutureOr<T2> synchronized<T2>(FutureOr<T2> Function() computation, {Duration? timeout});
}