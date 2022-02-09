import 'package:intl/intl.dart';
import 'package:true_core/src/core/typedef.dart';

import 'features/Logger/EAnsiColor.dart';
import 'features/Logger/ELogType.dart';

class TrueCoreSettings {
  static final TrueCoreSettings instance = new TrueCoreSettings();
  

  LogPrintFunction logHandler = _defaultLogHandler;


















  static final DateFormat _logFormat = new DateFormat('HH:mm:ss');
  static void _defaultLogHandler(DateTime date, ELogType type, Object? tag, Object? msg) {
    String time = _logFormat.format(date);

    if(msg == null) {
      tag = "";
      msg = tag;
    } else {
      tag = "[$tag] ";
      msg = "$msg";
    }

    String sType = ("[" + type.label + "]").padRight(8);

    final str = "[$time] $sType $tag$msg";
    final color = _enum2color(type).toAnsi();

    
    final sb = new StringBuffer();
    for(String s in str.split("\n"))
      sb.write(color + s + "\n");
    print(sb.toString());
  }


  static EAnsiColor _enum2color(ELogType type) {
    if(type == ELogType.INFO)
        return EAnsiColor.BRIGHT_BLUE;
    else if(type == ELogType.DEBUG)
        return EAnsiColor.BRIGHT_MAGENTA;
    else if(type == ELogType.WARN)
        return EAnsiColor.BRIGHT_YELLOW;
    else if(type == ELogType.ERROR)
        return EAnsiColor.BRIGHT_RED;
    else if(type == ELogType.ASSERT)
        return EAnsiColor.GREEN;
    return EAnsiColor.WHITE;
  }
}