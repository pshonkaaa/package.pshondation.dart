import 'package:true_core/src/core/common/IProcessResult/app/AppProcessError.dart';
import 'package:true_core/src/core/common/PrettyPrint.dart';

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