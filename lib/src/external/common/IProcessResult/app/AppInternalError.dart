import 'package:foundation/src/external/features/pretty_print/pretty_print.dart';

import 'AppProcessError.dart';

class AppInternalError extends AppProcessError {
  AppInternalError({
    super.error,
    super.stackTrace
  });

  @override
  bool get isDone => false;

  @override
  bool get isError => true;

  @override
  PrettyPrint toPrettyPrint() {
    final pp = new PrettyPrint(title: "AppInternalError");
    pp.append(super.toPrettyPrint());
    return pp;
  }
}