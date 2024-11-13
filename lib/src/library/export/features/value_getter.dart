import 'package:pshondation/library.dart';

import '../../private/features/value_getter_impl.dart';

abstract class ValueGetter<T> {
  const factory ValueGetter(
    GetterFunction<T> setter,
  ) = ValueGetterImpl;

  T get value;
}