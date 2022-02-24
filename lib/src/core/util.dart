import 'package:true_core/src/core/TrueCoreSettings.dart';
import 'package:true_core/src/core/features/Logger/ELogLevel.dart';

void printInfo(Object? tag, Object? msg)
  => TrueCoreSettings.instance.logHandler(DateTime.now(), ELogLevel.INFO, tag, msg);

void printDebug(Object? tag, Object? msg)
  => TrueCoreSettings.instance.logHandler(DateTime.now(), ELogLevel.DEBUG, tag, msg);

void printWarn(Object? tag, Object? msg)
  => TrueCoreSettings.instance.logHandler(DateTime.now(), ELogLevel.WARN, tag, msg);

void printError(Object? tag, Object? msg)
  => TrueCoreSettings.instance.logHandler(DateTime.now(), ELogLevel.ERROR, tag, msg);