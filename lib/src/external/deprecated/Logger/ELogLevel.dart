import 'package:true_core/src/external/deprecated/Logger/EAnsiColor.dart';

@deprecated
class ELogLevel {
  final String label;
  final int id;
  final EAnsiColor color;
  const ELogLevel(
    this.id,
    this.label,
    this.color,
  );

  static const values = [
    INFO,
    DEBUG,
    WARN,
    ERROR,
    ASSERT,
  ];
  
  static const ELogLevel INFO    = const ELogLevel(0, "INFO", EAnsiColor.BRIGHT_BLUE);
  static const ELogLevel DEBUG   = const ELogLevel(1, "DEBUG", EAnsiColor.BRIGHT_MAGENTA);
  static const ELogLevel WARN    = const ELogLevel(2, "WARN", EAnsiColor.BRIGHT_YELLOW);
  static const ELogLevel ERROR   = const ELogLevel(3, "ERROR", EAnsiColor.BRIGHT_RED);
  static const ELogLevel ASSERT  = const ELogLevel(4, "ASSERT", EAnsiColor.GREEN);

  @override
  bool operator ==(other) {
    return other is ELogLevel &&
            other.id == this.id;
  }

  @override
  int get hashCode => id;
}