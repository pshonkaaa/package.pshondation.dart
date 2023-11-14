import 'package:true_core/src/external/features/pretty_print/pretty_print.dart';

abstract class IProcessResult implements IPrettyPrint {
  bool get isDone;
  bool get isError;

  String toPrettyString() => toPrettyPrint().generate();
}