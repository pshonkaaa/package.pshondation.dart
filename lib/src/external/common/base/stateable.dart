import 'package:meta/meta.dart';
import 'package:true_core/library.dart';

abstract class BaseStateable implements IStateable {
  @override
  bool initialized = false;

  @override
  bool disposed = false;

  @override
  @mustCallSuper
  void initState() {
    initialized = true;
    disposed = false;
  }

  @override
  @mustCallSuper
  void dispose() {
    initialized = false;
    disposed = true;
  }
}