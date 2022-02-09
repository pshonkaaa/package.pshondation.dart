import 'package:true_core/src/core/common/PrettyPrint.dart';

abstract class IProcessResult implements IPrettyPrint {
  bool get isDone;
  bool get isError;

  String toPrettyString();
}