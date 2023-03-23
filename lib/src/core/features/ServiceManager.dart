import 'dart:async';

import 'package:true_core/src/core/extensions/IterableExtension.dart';

import 'Notifier/Notifier.dart';

abstract class AnService {
  bool get running => _running;
  bool get stopped => _stopped;

  Future<void> run();
  
  void stop();

  Future<void> waitForComplete()
    => _completer == null ? Future.value() : _completer!.future;

    
  
  bool _running = false;
  bool _stopped = true;
  Timer? _timer;
  Duration? _duration;
  Completer<void>? _completer;
  final Notifier<void> _onComplete = Notifier.empty();
}

abstract class ServiceManager {
  static final List<AnService> _services = [];

  static Future<void> start(
    AnService service, {
      Duration? repeatDuration,
  }) async {
    if(!_services.contains(service))
      _services.add(service);
    
    if(service._running)
      return;

    service._stopped = false;

    if(repeatDuration != null)
      service._duration = repeatDuration;
    
    await _runService(service);
  }

  static T? get<T extends AnService>() {
    return _services.tryFirstWhere((e) => e.runtimeType == T) as T?;
  }

  static Future<void> execute<T extends AnService>({
    bool waitUntilComplete = true,
  }) async {
    final service = get<T>()!;

    if(waitUntilComplete && service.running) {
      await service._completer!.future;
    }
    
    if(service.stopped)
      throw "Service $T has been already stopped";
    return await _runService(service);
  }

  static void setTimer(AnService service, Duration duration) {
    service._duration = duration;

    _runService(service);
  }

  static void stop(AnService service) {
    if(_services.contains(service))
      _services.remove(service);
    
    service._stopped = true;
    
    service.stop();
  }

  static Future<void> _runService(AnService service) async {
    if(service._running)
      return service._completer!.future;
    
    if(service._stopped)
      return;

    final completer = Completer();

    service._completer = completer;

    service._running = true;

    await service.run().then((_) {
      service._running = false;
      service._onComplete.notifyAll();
      completer.complete();
      _onStop(service);
    }, onError: (e, s) {
      service._running = false;
      service._stopped = true;
      service._onComplete.notifyAll();
      completer.completeError(e, s);
    });
  }

  static void _onStop(AnService service) {
    if(service._duration == null)
      return;
      
    service._timer = Timer(service._duration!, () {
      _runService(service);
    });
  }
}