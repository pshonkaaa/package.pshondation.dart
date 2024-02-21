import 'dart:async';

import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:pshondation/src/external/features/default_app_log_printer.dart';

abstract class AppLauncher {
  static Future<void> start(BaseAppMain app) async {
    await app.preLaunch();
    
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

      }, (o, s) => app.onError(o, s),
      zoneValues: app.zoneValues,
      zoneSpecification: app.zoneSpecification,
    );
  }

  static void close(BaseAppMain app) {
    app._closed = true;
    app.onExit(); //html.then((code) => exit(code));
  }

  static void defaultErrorHandler(
    BaseAppMain main,
    Object error,
    StackTrace stackTrace,
  ) {
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

    main.logger.e(msg);
  }
}

@Deprecated('use BaseAppMain')
abstract class IAppMain extends BaseAppMain {

}

abstract class BaseAppMain {
  late final String TAG = runtimeType.toString();
  
  static const Symbol _appMain = #AppMain;

  bool _closed = false;

  Logger logger = Logger(
    printer: DefaultAppLogPrinter.instance,
  );
  
  final Map<Object?, Object?> zoneValues = {};
  
  ZoneSpecification? zoneSpecification;

  @deprecated
  static void start(IAppMain app)
    => AppLauncher.start(app);

  @deprecated
  static void close(IAppMain app)
    => AppLauncher.close(app);

  @mustCallSuper
  Future<void> preLaunch() async {
    logger.d('$TAG > preLaunch');

    zoneValues[_appMain] = this;
  }

  @mustCallSuper
  Future<void> preInit() async {
    logger.d('$TAG > preInit');

  }

  @mustCallSuper
  Future<void> init() async {
    logger.d('$TAG > init');

  }

  @mustCallSuper
  Future<void> postInit() async {
    logger.d('$TAG > postInit');

  }

  @mustCallSuper
  Future<void> run() async {
    logger.d('$TAG > run');

  }

  void onError(Object error, StackTrace stackTrace)
    => AppLauncher.defaultErrorHandler(this, error, stackTrace);
  
  Future<int> onExit() async {
    return 0;
  }
}