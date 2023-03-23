import 'dart:async';
import 'dart:io' as io;

abstract class IAppMain {
  static void start(IAppMain app) {
    runZonedGuarded<void>(() async {
      await app.preInit();
      await app.init();
      await app.postInit();
      await app.run();
    }, (o, s) => app.onError(o, s));
  }

  static void close(IAppMain app) {
    app.onExit().then((code) => io.exit(code));
  }

  Future<void> preInit() async {

  }

  Future<void> init() async {

  }

  Future<void> postInit() async {

  }

  Future<void> run() async {

  }

  void onError(Object error, StackTrace stackTrace);
  
  Future<int> onExit() async {
    return 0;
  }
}