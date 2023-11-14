// import 'dart:async';

// @Deprecated("Need to review")
// class TimedTask<T> {
//   final Duration duration;
//   final Future<T?> future;
//   TimedTask(this.duration, this.future);

//   Future<OUT?> run<OUT>(OUT? onResult, [OUT? onTimeout]) {
//     var completer = new Completer<OUT?>();
//     scheduleMicrotask(() async {
//       var timer = new Timer(duration, () {
//         if(!completer.isCompleted)
//           completer.complete(onTimeout);
//       });
//       try {
//         await future;
//       } catch(e, s) {
//         if(!completer.isCompleted)
//           completer.completeError(e, s);
//         return;
//       } finally {
//         timer.cancel();
//       } if(!completer.isCompleted)
//         completer.complete(onResult);
//     });
//     return completer.future;
//   }

//   Future<T?> runWithResult([T? onTimeout]) {
//     var completer = new Completer<T?>();
//     scheduleMicrotask(() async {
//       var timer = new Timer(duration, () {
//         if(!completer.isCompleted)
//           completer.complete(onTimeout);
//       });
//       T? result;
//       try {
//         result = await future;
//       } catch(e, s) {
//         if(!completer.isCompleted)
//           completer.completeError(e, s);
//         return;
//       } finally {
//         timer.cancel();
//       } if(!completer.isCompleted)
//         completer.complete(result);
//     });
//     return completer.future;
//   }
// }