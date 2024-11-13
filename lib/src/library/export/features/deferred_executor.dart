import 'dart:async';

import 'package:pshondation/library.dart';

import '../../private/features/deferred_executor_impl.dart';

/// [DeferredExecutor] обеспечивает отложенное выполнение задач. Если новая задача 
/// запланирована до завершения текущей, она заменяет предыдущую, гарантируя, что 
/// всегда будет выполнена самая последняя запланированная задача.
///
/// Этот класс полезен для ситуаций, где важно завершить последнюю запланированную 
/// задачу, например, в случае обновлений данных, когда старые задачи могут быть 
/// отменены и заменены новыми.
abstract class DeferredExecutor<T> {
  factory DeferredExecutor()
    => DeferredExecutorImpl();

  /// Возвращает `true`, если отложенная задача ожидает выполнения,
  /// и `false`, если задач в ожидании нет.
  bool get isPending;

  /// Возвращает `true`, если выполняется.
  bool get isExecuting;

  /// Возвращает [Future], который завершится после завершения всех задач.
  Future<void> get future;

  /// Возвращает [Future], который завершится после того, как задача перейдет из ожидания
  /// и впоследствии выполнится. Если задачи нет, то завершится сразу.
  /// 
  /// Пример:
  /// ```
  /// final executor = DeferredExecutor();
  /// 
  /// executor.call(() {
  ///   print('task 1 start');
  ///   Future.delayed(Duration(seconds: 5));
  ///   print('task 1 executed');
  /// });
  /// 
  /// executor.nextTaskFuture.then((_) {
  ///   print('after task 1 future || immediately print');
  /// });
  /// 
  /// executor.call(() {
  ///   print('task 2 start');
  ///   Future.delayed(Duration(seconds: 4));
  ///   print('task 2 executed');
  /// });
  /// 
  /// executor.nextTaskFuture.then((_) {
  ///   print('after task 2 future');
  /// });
  /// 
  /// executor.call(() {
  ///   print('task 3 start');
  ///   Future.delayed(Duration(seconds: 3));
  ///   print('task 3 executed');
  /// });
  /// 
  /// executor.nextTaskFuture.then((_) {
  ///   print('after task 3 future');
  /// });
  /// 
  /// // Output:
  /// // task 1 start
  /// // after task 1 future || immediately print
  /// // task 1 executed
  /// // task 3 start
  /// // task 3 executed
  /// // after task 2 future
  /// // after task 3 future
  /// 
  /// ```
  Future<void> get nextTaskFuture;

  /// Добавляет новую задачу в очередь и начинает выполнение. 
  ///
  /// Если в текущий момент другая задача выполняется, [callback] будет добавлен в очередь
  /// и выполнится позже, после завершения текущей задачи.
  ///
  /// Метод [call] работает синхронно и немедленно возвращает управление. 
  /// Если [callback] — асинхронный, его выполнение начнётся асинхронно,
  /// но [call] не дожидается его завершения и возвращается сразу после добавления
  /// задачи в очередь.
  void call(FutureOrVoidCallback callback);
}