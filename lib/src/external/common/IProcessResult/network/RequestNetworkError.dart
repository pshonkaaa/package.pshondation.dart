import 'package:foundation/src/external/common/IProcessResult/app/AppProcessError.dart';
import 'package:foundation/src/external/features/pretty_print/pretty_print.dart';

class RequestNetworkError extends AppProcessError {
  final bool connected;

  final bool protoDone;

  final bool incorrectResponse;
  RequestNetworkError({
    required this.connected,
    required this.protoDone,
    required this.incorrectResponse,
    super.error,
    super.stackTrace
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
}