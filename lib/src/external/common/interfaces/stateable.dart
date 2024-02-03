import 'dart:async';

import 'package:true_core/library.dart';

abstract class IStateable implements IDisposable {
  bool get initialized;

  void initState();
}

abstract class IAsyncStateable implements IStateable, IAsyncDisposable {
  Future<void> initState();
}