import 'package:true_core/src/core/common/IProcessResult/interfaces/IProcessResult.dart';
import 'package:true_core/src/core/common/PrettyPrint.dart';

class AppProcessDone implements IProcessResult {
  const AppProcessDone();
  
  @override
  bool get isDone => true;

  @override
  bool get isError => false;

  @override
  PrettyPrint toPrettyPrint() {
    final pp = new PrettyPrint(title: "AppProcessDone");
    pp.add("isDone", isDone);
    pp.add("isError", isError);
    return pp;
  }

  @override
  String toPrettyString() => toPrettyPrint().generate();
}