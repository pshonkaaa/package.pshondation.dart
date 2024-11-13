import 'package:pshondation/src/export/common/IProcessResult/app/AppProcessError.dart';
import 'package:pshondation/src/export/features/pretty_print/pretty_print.dart';

class RequestResultCanceledError extends AppProcessError {
  RequestResultCanceledError({
    super.error,
    super.stackTrace
  });

  @override
  PrettyPrint toPrettyPrint() {
    final pp = new PrettyPrint(title: "RequestResultCanceledError");
    pp.add("isDone", isDone);
    pp.add("isError", isError);
    pp.append(super.toPrettyPrint());
    return pp;
  }
}