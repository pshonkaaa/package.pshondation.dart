import 'dart:async';

abstract class AppLauncher {
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

  static void defaultErrorHandler(Object error, StackTrace stackTrace) {
    final sb = StringBuffer();
    sb.writeln("THE APPLICATION GOT AN UNCAUGHT EXCEPTION");
    sb.writeln("-----------------------------------------");
    sb.writeln("Error:  $error");

    sb.writeln("StackTrace:");
    for(final line in stackTrace.toString().split(RegExp("\n"))) {
      sb.writeln(line);
    }
    sb.writeln("-----------------------------------------");

    final msg = sb.toString();
    print(msg);
    
  }
  
}

abstract class IAppMain {
  bool _closed = false;

  @deprecated
  static void start(IAppMain app)
    => AppLauncher.start(app);

  @deprecated
  static void close(IAppMain app)
    => AppLauncher.close(app);

  Future<void> preInit() async {

  }

  Future<void> init() async {

  }

  Future<void> postInit() async {

  }

  Future<void> run() async {

  }

  void onError(Object error, StackTrace stackTrace)
    => AppLauncher.defaultErrorHandler(error, stackTrace);
  
  Future<int> onExit() async {
    return 0;
  }
}