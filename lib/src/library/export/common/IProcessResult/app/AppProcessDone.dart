import 'package:pshondation/src/library/export/common/IProcessResult/interfaces/IProcessResult.dart';
import 'package:pshondation/src/library/export/features/pretty_print/pretty_print.dart';

class AppProcessDone implements IProcessResult {
  const AppProcessDone();
  
  @override
  bool get isDone => true;

  @override
  bool get isError => false;

  @override
  PrettyPrint toPrettyPrint() {
    final pp = PrettyPrint(title: this);
    pp.add("isDone", isDone);
    pp.add("isError", isError);
    return pp;
  }

  @override
  String toPrettyString() => toPrettyPrint().generate();
}