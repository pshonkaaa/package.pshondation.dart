import 'dart:async';

import 'package:foundation/src/external/extensions/IterableExtension.dart';

import '../notifier/external/notifier.dart';

abstract class BaseService {
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

class DelegatedService extends BaseService {
  final Function runner;
  final Function? stopper;
  DelegatedService({
    required this.runner,
    this.stopper,
  });
  
  @override
  Future<void> run() async {
    await runner();
  }

  @override
  void stop() {
    stopper?.call();
  }
  
}

abstract class ServiceManager {
  static final List<BaseService> _services = [];

  static Future<void> start(
    BaseService service, {
      Duration? repeatInterval,
  }) async {
    if(!_services.contains(service))
      _services.add(service);
    
    if(service._running)
      return;

    service._stopped = false;

    if(repeatInterval != null)
      service._duration = repeatInterval;
    
    await _runService(service);
  }

  static T? get<T extends BaseService>() {
    return _services.tryFirstWhere((e) => e.runtimeType == T) as T?;
  }

  static Future<void> execute<T extends BaseService>({
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

  static void setTimer(BaseService service, Duration duration) {
    service._duration = duration;

    _runService(service);
  }

  static void stop(BaseService service) {
    if(_services.contains(service))
      _services.remove(service);
    
    service._stopped = true;
    
    service.stop();
  }

  static Future<void> _runService(BaseService service) async {
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

  static void _onStop(BaseService service) {
    if(service._duration == null)
      return;
      
    service._timer = Timer(service._duration!, () {
      _runService(service);
    });
  }
}