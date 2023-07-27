import 'dart:async';

abstract class IAppMain {
  bool _closed = false;

  static void start(IAppMain app) {
    runZonedGuarded<void>(() async {
      await app.preInit();
      if(app._closed)
        return;

      await app.init();
      if(app._closed)
        return;

      await app.postInit();
      if(app._closed)
        return;
        
      await app.run();
    }, (o, s) => app.onError(o, s));
  }

  static void close(IAppMain app) {
    app._closed = true;
    app.onExit(); //html.then((code) => exit(code));
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