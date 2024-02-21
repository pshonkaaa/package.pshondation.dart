import 'package:foundation/src/external/common/IProcessResult/interfaces/IProcessResult.dart';
import 'package:foundation/src/external/features/pretty_print/pretty_print.dart';

class AppProcessError implements IProcessResult {
  final Object? error;
  final StackTrace? stackTrace;
  const AppProcessError({
    required this.error,
    required this.stackTrace,
  });

  @override
  bool get isDone => false;

  @override
  bool get isError => true;

  @override
  PrettyPrint toPrettyPrint() {
    final pp = new PrettyPrint(title: "AppProcessError");
    pp.add("error", error);
    pp.add("stackTrace", stackTrace);
    pp.add("isDone", isDone);
    pp.add("isError", isError);
    return pp;
  }

  @override
  String toPrettyString() => toPrettyPrint().generate();

  @override
  String toString() {
    final sb = StringBuffer();
    sb.writeln(this.runtimeType.toString());
    if(error != null)
      sb.writeln("Caused by $error");
    if(stackTrace != null) {
      sb.writeln("Stacktrace:");
      sb.writeln(stackTrace);
    } return sb.toString();
  }
}