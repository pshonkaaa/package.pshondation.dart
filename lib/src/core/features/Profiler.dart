import 'dart:async';

import 'package:true_core/src/core/common/TimeUnits.dart';
import 'package:true_core/src/core/util.dart';

/// ### Usage:
/// ```
/// final p = new Profiler..start();
/// for(int i = 0; i < 1000000; i++)
///   continue;
/// p.end();
/// print(p.time(TimeUnits.MILLISECONDS).toString() + " ms");
/// ```
///
/// ### Additional usage:
/// ```
/// final pContainer = new Profiler();
/// 
/// final p1 = new Profiler()..start()..addTo(pContainer);
/// for(int i = 0; i < 1000000; i++)
///   continue;
/// p1.end();
/// 
/// final p2 = new Profiler()..start()..addTo(pContainer);
/// for(int i = 0; i < 100000; i++)
///   continue;
/// p2.end();
/// 
/// await Future.delayed(const Duration(seconds: 2));
/// 
/// // Lets say p1 took 100ms, and p2 10ms,
/// // than result will be 110 ms
/// print(pContainer.time(TimeUnits.MILLISECONDS).toString() + " ms");
/// ```
abstract class Profiler {
  static bool handleLongOperations = false;
  static Duration warnExecutionTime = Duration(seconds: 1);

  factory Profiler([
    String name = "none",
  ]) => _Profiler(
    name,
  );

  /// Name of profiler
  String get name;

  /// True, if profiler running
  bool get isRunning;

  /// Returns elapsed time after **profiler.start()**
  Duration get elapsed;

  /// Starts profiler
  Profiler start();

  /// Stops profiler, and children if [stopAll] == true
  Profiler stop({bool stopAll = true});

  /// Adding child
  Profiler add(Profiler p);
  
  /// Adding it to parent
  Profiler addTo(Profiler p);

  /// Getting elapsed time
  int time(TimeUnits units);

  /// Converts to human-readable string
  String stringify(TimeUnits units);
  
  String toString();
}



class _Profiler implements Profiler {
  static const String TAG = "Profiler";

  final Stopwatch sw = new Stopwatch();
  final List<_Profiler> children = [];

  @override
  final String name;

  _Profiler([
    String name = "none",
  ]) : name = name;

  @override
  bool get isRunning {
    if(sw.isRunning)
      return true;
    for(final child in children) {
      if(child.isRunning)
        return true;
    } return false;
  }

  Duration get elapsed => sw.elapsed;
  
  @override
  _Profiler start() {
    sw.start();

    if(Profiler.handleLongOperations)
      _ProfileWatcher.instace.watch(this);
    return this;
  }

  @override
  Profiler stop({bool stopAll = true}) {
    _ProfileWatcher.instace.stopWatch(this);

    sw.stop();
    if(stopAll) {
      for(final child in children)
        child.stop();
    } return this;
  }

  @override
  Profiler add(covariant _Profiler p) {
    children.add(p);
    return this;
  }

  @override
  Profiler addTo(covariant _Profiler p) {
    p.add(this);
    return this;
  }

  @override
  int time(TimeUnits unit) {
    int i = 0;
    for(final p in children) {
      i += p.time(unit);
    }

    switch(unit) {
      case TimeUnits.DAYS:
        i += sw.elapsed.inDays;
        break;
      case TimeUnits.MINUTES:
        i += sw.elapsed.inMinutes;
        break;
      case TimeUnits.SECONDS:
        i += sw.elapsed.inSeconds;
        break;
      case TimeUnits.MILLISECONDS:
        i += sw.elapsed.inMilliseconds;
        break;
      case TimeUnits.MICROSECONDS:
        i += sw.elapsed.inMicroseconds;
        break;
      case TimeUnits.TICKS:
        i += sw.elapsedTicks;
        break;
      default:
        throw(new Exception("Unknown time unit $unit"));
    } return i;
  }

  @override
  String stringify(TimeUnits units) {
    final i = time(units);
    return '[$TAG] "$name" took $i times in ' + units.stringify();
  }
  
  @override
  String toString() => "Profiler(inMicroseconds: ${time(TimeUnits.MICROSECONDS).toString()})";
}

class _ProfileWatcher {
  static final _ProfileWatcher instace = new _ProfileWatcher();
  
  final List<_Profiler> profilers = [];

  void watch(_Profiler p) {
    profilers.add(p);
    _start();
  }

  void stopWatch(_Profiler p) {
    if(profilers.remove(p)) {
      if(p.elapsed > Profiler.warnExecutionTime)
        _debugProfiler(p);
    }
  }

  
  Timer? _timer;
  static const TimeUnits timeUnit = TimeUnits.MILLISECONDS;
  void _start() {
    if(_timer?.isActive ?? false)
      return;
    _timer = new Timer(Duration(milliseconds: 500), () {
      for(final p in profilers) {
        if(p.elapsed > Profiler.warnExecutionTime) {
          _debugProfiler(p);
        }
      }
      

      if(profilers.isEmpty)
        return;
      _start();
    });
  }

  void _debugProfiler(Profiler p) {
    printWarn(_Profiler.TAG, "${p.name} was executing ${p.time(timeUnit)} times in $timeUnit");
  }
}