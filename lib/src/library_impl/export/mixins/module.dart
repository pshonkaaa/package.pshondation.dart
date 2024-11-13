import 'package:meta/meta.dart';
import 'package:pshondation/library.dart';
import 'package:pshondation/library_impl.dart';


mixin ModuleMixin on AsyncStateableMixin implements Module {
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