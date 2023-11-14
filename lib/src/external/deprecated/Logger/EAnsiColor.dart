@deprecated
enum EAnsiColor {
  RESET,

  BLACK,
  RED,
  GREEN,
  YELLOW,
  BLUE,
  MAGENTA,
  CYAN,
  WHITE,

  /// GRAY
  BRIGHT_BLACK,
  BRIGHT_RED,
  BRIGHT_GREEN,
  BRIGHT_YELLOW,
  BRIGHT_BLUE,
  BRIGHT_MAGENTA,
  BRIGHT_CYAN,
  BRIGHT_WHITE,
}

@deprecated
extension AnsiColorExtension on EAnsiColor {
  String toAnsi() {    
    switch(this) {
      case EAnsiColor.RESET:
        return "\x1b[0m";

      case EAnsiColor.BLACK:
        return "\x1b[30m";
      case EAnsiColor.RED:
        return "\x1b[31m";
      case EAnsiColor.GREEN:
        return "\x1b[32m";
      case EAnsiColor.YELLOW:
        return "\x1b[33m";
      case EAnsiColor.BLUE:
        return "\x1b[34m";
      case EAnsiColor.MAGENTA:
        return "\x1b[35m";
      case EAnsiColor.CYAN:
        return "\x1b[36m";
      case EAnsiColor.WHITE:
        return "\x1b[37m";

      case EAnsiColor.BRIGHT_BLACK:
        return "\x1b[90m";
      case EAnsiColor.BRIGHT_RED:
        return "\x1b[91m";
      case EAnsiColor.BRIGHT_GREEN:
        return "\x1b[92m";
      case EAnsiColor.BRIGHT_YELLOW:
        return "\x1b[93m";
      case EAnsiColor.BRIGHT_BLUE:
        return "\x1b[94m";
      case EAnsiColor.BRIGHT_MAGENTA:
        return "\x1b[95m";
      case EAnsiColor.BRIGHT_CYAN:
        return "\x1b[96m";
      case EAnsiColor.BRIGHT_WHITE:
        return "\x1b[97m";
    }
  }
}