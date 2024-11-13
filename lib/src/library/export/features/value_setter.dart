import 'package:pshondation/library.dart';

import '../../private/features/value_setter_impl.dart';

abstract class ValueSetter<T> {
  const factory ValueSetter(
    SetterFunction<T> setter,
  ) = ValueSetterImpl;

  set value(T newValue);
}