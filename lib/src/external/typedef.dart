
import 'package:pshondation/library.dart';

typedef LogPrintFunction = void Function(DateTime date, ELogLevel level, Object? tag, Object? msg);


typedef StreamOnDataCallback<T> = void Function(T data);