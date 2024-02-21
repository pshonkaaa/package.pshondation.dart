import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:pshondation/src/external/features/stacktrace/stackframe.dart';

typedef StackTraceConverter = List<StackFrame> Function(StackTrace stackTrace);

/// Outputs simple log messages:
/// ```
/// [E] Log message  ERROR: Error info
/// ```
class DefaultAppLogPrinter extends LogPrinter {
  static final instance = DefaultAppLogPrinter(
    printTime: true,
    colors: true,
  );

  static final levelPrefixes = {
    Level.trace: '[T]',
    Level.debug: '[D]',
    Level.info: '[I]',
    Level.warning: '[W]',
    Level.error: '[E]',
    Level.fatal: '[FATAL]',
  };

  static final levelColors = {
    Level.trace: AnsiColor.fg(AnsiColor.grey(0.5)),
    Level.debug: const AnsiColor.none(),
    Level.info: const AnsiColor.fg(12),
    Level.warning: const AnsiColor.fg(208),
    Level.error: const AnsiColor.fg(196),
    Level.fatal: const AnsiColor.fg(199),
  };

  DefaultAppLogPrinter({
    this.printTime = false,
    this.colors = true,
    this.stackTraceConverter = defaultStackTraceConverter,
  });

  final bool printTime;
  
  final bool colors;

  StackTraceConverter stackTraceConverter;

  @override
  List<String> log(LogEvent event) {
    final messageStr = _stringifyMessage(event.message);
    final errorStr = event.error != null ? '  ERROR: ${event.error}' : '';
    final timeStr = printTime ? '[${_extractTime(event.time)}]' : '';
    return [
      '${_labelFor(event.level)} $timeStr $messageStr$errorStr',
      if(event.stackTrace != null)...[
        'StackTrace:',
        // ...event.stackTrace!.toString().split('\n').map((e) => '   $e').toList(),
        ..._extractStacktrace(event.stackTrace!),
      ],
    ];
  }

  // DateFormat('yyyy-MM-dd');
  static final DateFormat _dateFormat = DateFormat('HH:mm:ss');

  String _extractTime(DateTime time) {
    return _dateFormat.format(time) + '.' + time.millisecond.toString().padLeft(3, '0');
  }

  List<String> _extractStacktrace(StackTrace stackTrace) {
    final frames = stackTraceConverter(stackTrace);
    
    final List<String> lines = frames.map((e) {
      return '   at ${e.method} (${e.source}:${e.column})';
    }).toList();
    
    return lines;
  }

  static List<StackFrame> defaultStackTraceConverter(StackTrace stackTrace) {
    final List<StackFrame> frames = StackFrame.fromStackTrace(stackTrace);
    return frames;
  }



  String _labelFor(Level level) {
    var prefix = levelPrefixes[level]!;
    var color = levelColors[level]!;

    return colors ? color(prefix) : prefix;
  }

  final _rTagParser = RegExp(r'^((.*?) > )?(.*)', dotAll: true);
  
  String _stringifyMessage(dynamic message) {
    final finalMessage = message is Function ? message() : message;

    // encoder.convert -> Convert error
    // if (finalMessage is Map || finalMessage is Iterable) {
    //   var encoder = const JsonEncoder.withIndent(null);
    //   return encoder.convert(finalMessage);
    // } else
    
    if(finalMessage is String) {
      final match = _rTagParser.allMatches(message).first;
      final sb = StringBuffer();

      if(match.group(2) != null) {
        sb.write('[${match.group(2)!}] ');
      }

      sb.write(match.group(3)!);

      return sb.toString();
    } else {
      return finalMessage.toString();
    }
  }
}
