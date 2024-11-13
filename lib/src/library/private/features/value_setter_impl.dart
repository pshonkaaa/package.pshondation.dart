import 'package:pshondation/library.dart';

class ValueSetterImpl<T> implements ValueSetter<T> {
  const ValueSetterImpl(
    this.setter,
  );

  final SetterFunction<T> setter;
  
  @override
  set value(T newValue)
    => setter(newValue);
  
}