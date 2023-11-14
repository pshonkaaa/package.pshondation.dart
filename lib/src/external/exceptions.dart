class NullPointerException implements Exception {
  final String param;
  NullPointerException(this.param);

  @override
  String toString() => "$param is null.";
}

class CanceledException implements Exception {
  CanceledException();

  @override
  String toString() => "CanceledException";
}

class UnknownException implements Exception {
  final String msg;
  UnknownException(this.msg);

  @override
  String toString() => "UnknownException: $msg";
}

class CausedByException implements Exception {
  final String message;
  final Object cause;
  final StackTrace stacktrace;
  CausedByException(this.message, this.cause, this.stacktrace);

  @override
  String toString() => (message.isEmpty ? "" : "$message\n") + "Caused by: $cause\nStackTrace:\n$stacktrace";
}