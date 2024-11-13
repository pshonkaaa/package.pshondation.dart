import 'package:pshondation/library.dart';

class ValueGetterImpl<T> implements ValueGetter<T> {
  const ValueGetterImpl(
    this.getter,
  );

  final GetterFunction<T> getter;
  
  @override
  T get value
    => getter();
  
}