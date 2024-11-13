import 'package:pshondation/library.dart';

class ValueReferenceImpl<T> implements ValueReference<T> {
  const ValueReferenceImpl(
    this.getter,
    this.setter,
  );

  final GetterFunction<T> getter;

  final SetterFunction<T> setter;

  @override
  T get value => getter();
  
  @override
  set value(T newValue) => setter(newValue);
  
}