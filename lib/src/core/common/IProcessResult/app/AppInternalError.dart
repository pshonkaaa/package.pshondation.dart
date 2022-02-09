import 'package:true_core/src/core/common/PrettyPrint.dart';

import 'AppProcessError.dart';

class AppInternalError extends AppProcessError {
  @override
  final Object? error;

  @override
  final StackTrace? stackTrace;
  AppInternalError({
    this.error,
    this.stackTrace,
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