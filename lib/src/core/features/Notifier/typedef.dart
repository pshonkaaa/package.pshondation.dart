import 'package:true_core/src/core/features/Notifier/NotifierSubscription.dart';

typedef NotifierConventer<SRC, DST> = DST Function(SRC value);

typedef NotifierCallback<T> = void Function(T value);

typedef NotifierSubscriptionConverter<T> = NotifierSubscription Function(T value);