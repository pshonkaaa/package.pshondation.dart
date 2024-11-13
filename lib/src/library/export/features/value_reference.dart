import 'package:pshondation/library.dart';

import '../../private/features/value_reference_impl.dart';

abstract class ValueReference<T> implements ValueSetter<T>, ValueGetter<T> {
  const factory ValueReference(
    GetterFunction<T> getter,
    SetterFunction<T> setter,
  ) = ValueReferenceImpl;
  
  @override
  abstract T value;
}