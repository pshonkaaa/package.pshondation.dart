import 'package:meta/meta.dart';
import 'package:pshondation/library.dart';
import 'package:pshondation/library_impl.dart';

abstract class BaseModule extends BaseAsyncStateable implements Module {
  late NotifierStorage storage;
  
  @override
  @mustCallSuper
  Future<void> initState() async {
    storage = NotifierStorage();
    
    await super.initState();
  }
  
  @override
  @mustCallSuper
  Future<void> dispose() async {
    await super.dispose();

    storage.dispose();
  }
}

// abstract class BaseModule implements Module {

//   final storage = NotifierStorage();

//   @override
//   bool get initialized => _initialized;

//   @override
//   bool get disposed => _disposed;

//   bool _initialized = false;
  
//   bool _disposed = false;

//   @override
//   @mustCallSuper
//   Future<void> initState() async {
//     _initialized = true;
//     _disposed = false;
//   }

//   @override
//   @mustCallSuper
//   Future<void> dispose() async {
//     _initialized = false;
//     _disposed = true;

//     storage.clear();
//   }
  
// }