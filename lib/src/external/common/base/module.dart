import 'package:meta/meta.dart';
import 'package:foundation/library.dart';

abstract class BaseModule implements IModule {
  final storage = NotifierStorage();

  @override
  bool get initialized => _initialized;

  @override
  bool get disposed => _disposed;

  bool _initialized = false;
  
  bool _disposed = false;

  @override
  @mustCallSuper
  Future<void> initState() async {
    _initialized = true;
    _disposed = false;
  }

  @override
  @mustCallSuper
  Future<void> dispose() async {
    _initialized = false;
    _disposed = true;

    storage.clear();
  }
  
}