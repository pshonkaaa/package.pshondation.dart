class ErrorDescription {
  const ErrorDescription({
    required this.error,
    required this.stackTrace,
  });

  final Object error;
  final StackTrace stackTrace;
}