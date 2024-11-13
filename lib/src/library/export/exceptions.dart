abstract class ExceptionsKit {
  static Exception alreadyStarted(Object object)
    => Exception('${object.runtimeType} has been already started');

  static Exception alreadyInitialized(Object object)
    => Exception('${object.runtimeType} has been already initialized');

  static Exception notInitialized(Object object)
    => Exception('${object.runtimeType} has not been initialized');

  static Exception alreadyDisposed(Object object)
    => Exception('${object.runtimeType} has been already disposed');

  static Exception objectNotSupported(Object object)
    => notSupported('${object.runtimeType}');

  static Exception notSupported([String? message])
    => Exception(message == null ? 'Operation not supported' : '$message is not supported');
}


@Deprecated('Kakoi pointer? lol, prosto null')
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

class UnreachableException implements Exception {
  final String msg;
  UnreachableException([this.msg = '']);

  @override
  String toString() => "UnreachableException: $msg";
}

class CausedByException implements Exception {
  CausedByException(
    this.cause,
    this.stacktrace,
  );

  final Object cause;
  
  final StackTrace stacktrace;

  @override
  // String toString() => (message.isEmpty ? "" : "$message\n") + "Caused by: $cause\nStackTrace:\n$stacktrace";
  String toString() => 'Caused by: $cause\nStackTrace:\n$stacktrace';
}