import 'package:true_core/src/core/TrueCoreSettings.dart';
import 'package:true_core/src/core/features/Logger/ELogType.dart';

void printInfo(Object? tag, Object? msg)
  => TrueCoreSettings.instance.logHandler(DateTime.now(), ELogType.INFO, tag, msg);

void printDebug(Object? tag, Object? msg)
  => TrueCoreSettings.instance.logHandler(DateTime.now(), ELogType.DEBUG, tag, msg);

void printWarn(Object? tag, Object? msg)
  => TrueCoreSettings.instance.logHandler(DateTime.now(), ELogType.WARN, tag, msg);

void printError(Object? tag, Object? msg)
  => TrueCoreSettings.instance.logHandler(DateTime.now(), ELogType.ERROR, tag, msg);