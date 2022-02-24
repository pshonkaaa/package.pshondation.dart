class ELogLevel {
  final String label;
  final int id;
  const ELogLevel(this.id, this.label);
  

  static const ELogLevel INFO    = const ELogLevel(0, "INFO");
  static const ELogLevel DEBUG   = const ELogLevel(1, "DEBUG");
  static const ELogLevel WARN    = const ELogLevel(2, "WARN");
  static const ELogLevel ERROR   = const ELogLevel(3, "ERROR");
  static const ELogLevel ASSERT  = const ELogLevel(4, "ASSERT");

  @override
  bool operator ==(other) {
    return other is ELogLevel &&
            other.id == this.id;
  }

  @override
  int get hashCode => id;
}