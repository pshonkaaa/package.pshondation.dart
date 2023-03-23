import 'dart:async';

typedef SchedulerRunnable = Future<void> Function();

abstract class SchedulerTask {
  final bool sync;
  SchedulerTask({
    this.sync = true,
  });

  bool get isCancelled => _isCancelled;
  
  Future get onComplete => _completer.future;

  Future<void> run();

  void cancel() => _isCancelled = true;


  Completer<void> _completer = Completer();
  bool _isCancelled = false;
}

class Scheduler {
  static final instance = Scheduler._();

  Scheduler._();

  SchedulerTask add({
    SchedulerTask? task,
    SchedulerRunnable? runnable,
    Duration duration = const Duration(seconds: 0),
    bool sync = true,
  }) {
    if(task == null && runnable == null)
      throw "requires task or runnable";

    if(task == null) {
      task = _ScheduleTaskImpl(
        runnable: runnable!,
        sync: sync,
      );
    }

    Timer(duration, () {
      _queue.add(task!);
    });
    return task;
  }

  SchedulerTask addPeriodic({
    SchedulerTask? task,
    SchedulerRunnable? runnable,
    required Duration duration,
    bool immediately = false,
    bool sync = true,
  }) {
    if(task == null && runnable == null)
      throw "requires task or runnable";

    if(task == null) {
      task = _ScheduleTaskImpl(
        runnable: runnable!,
        sync: sync,
      );
    }
    
    _startPeriodic(
      task,
      duration,
      immediately: immediately,
    );
    return task;
  }

  void _startPeriodic(
    SchedulerTask task,
    Duration duration, {
      required bool immediately,
  }) {
    Future<void> execute() async {
      if(task.isCancelled)
        return;
      _queue.add(task);
      await task.onComplete;
      if(task.isCancelled)
        return;
      task._completer = Completer();
      _startPeriodic(task, duration, immediately: false);
    }

    if(immediately) {
      execute();
      return;
    } Timer(duration, () => execute());
  }




  
  final List<SchedulerTask> _queue = [];

  Future<void> execute() async {
    final List<Future> futures = [];
    while(_queue.isNotEmpty) {
      final task = _queue.removeAt(0);
      final result = task.run();
      result.then((_) => task._completer.complete());

      futures.add(result);
      if(task.sync)
        await result;
    } await Future.wait(futures);
  }
}

class _ScheduleTaskImpl extends SchedulerTask {
  final SchedulerRunnable runnable;
  _ScheduleTaskImpl({
    required this.runnable,
    required super.sync,
  });

  @override
  Future<void> run() async {
    await runnable();
  }
  
}