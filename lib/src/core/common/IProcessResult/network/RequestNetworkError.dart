import 'package:true_core/src/core/common/IProcessResult/app/AppProcessError.dart';
import 'package:true_core/src/core/common/PrettyPrint.dart';

class RequestNetworkError extends AppProcessError {
  final bool connected;

  final bool protoDone;

  final bool incorrectResponse;
  
  @override
  final Object? error;
  
  @override
  final StackTrace? stackTrace;
  RequestNetworkError({
    required this.connected,
    required this.protoDone,
    required this.incorrectResponse,
    this.error,
    this.stackTrace,
  });
  
  @override
  PrettyPrint toPrettyPrint() {
    final pp = new PrettyPrint(title: "RequestNetworkError");
    pp.add("connected", connected);
    pp.add("protoDone", protoDone);
    pp.add("incorrectResponse", incorrectResponse);
    pp.append(super.toPrettyPrint());
    return pp;
  }

  @override
  String toString()
    => (error == null ? "Нет соединения" : "\nError: $error\nStacktrace: $stackTrace");
}