

class ELogType {
  final String label;
  final int id;
  const ELogType(this.id, this.label);
  

  static const ELogType INFO    = const ELogType(0, "INFO");
  static const ELogType DEBUG   = const ELogType(1, "DEBUG");
  static const ELogType WARN    = const ELogType(2, "WARN");
  static const ELogType ERROR   = const ELogType(3, "ERROR");
  static const ELogType ASSERT  = const ELogType(4, "ASSERT");

  @override
  bool operator ==(other) {
    return other is ELogType &&
            other.id == this.id;
  }

  @override
  int get hashCode => id;
}