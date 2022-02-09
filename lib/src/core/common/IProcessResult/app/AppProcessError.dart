import 'package:true_core/src/core/common/IProcessResult/interfaces/IProcessResult.dart';
import 'package:true_core/src/core/common/PrettyPrint.dart';

abstract class AppProcessError implements IProcessResult {
  Object? get error;

  StackTrace? get stackTrace;

  @override
  bool get isDone => false;

  @override
  bool get isError => true;

  @override
  PrettyPrint toPrettyPrint() {
    final pp = new PrettyPrint(title: "AppProcessError");
    pp.add("isDone", isDone);
    pp.add("isError", isError);
    pp.add("error", error);
    pp.add("stackTrace", stackTrace);
    // if(error != null) {
    //   msg += "\nError: $error";
    //   msg += "\nStacktrace: $stackTrace";
    // } 
    return pp;
  }

  @override
  String toPrettyString() => toPrettyPrint().generate();
}