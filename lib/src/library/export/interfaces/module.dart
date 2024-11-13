import 'package:pshondation/library.dart';

abstract class Module implements AsyncStateable {
  @override
  bool get initialized;

  @override
  bool get disposed;

  @override
  Future<void> initState();
  
  @override
  Future<void> dispose();
}