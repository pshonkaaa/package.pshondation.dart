// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:meta/meta.dart';

/// A object representation of a frame from a stack trace.
///
/// {@tool snippet}
///
/// This example creates a traversable list of parsed [StackFrame] objects from
/// the current [StackTrace].
///
/// ```dart
/// final List<StackFrame> currentFrames = StackFrame.fromStackTrace(StackTrace.current);
/// ```
/// {@end-tool}
@immutable
class StackFrame {
  /// Creates a new StackFrame instance.
  ///
  /// All parameters must not be null. The [className] may be the empty string
  /// if there is no class (e.g. for a top level library method).
  const StackFrame({
    required this.number,
    required this.column,
    required this.line,
    required this.packageScheme,
    required this.package,
    required this.packagePath,
    this.className = '',
    required this.method,
    this.isConstructor = false,
    required this.source,
  });

  /// A stack frame representing an asynchronous suspension.
  static const StackFrame asynchronousSuspension = StackFrame(
    number: -1,
    column: -1,
    line: -1,
    method: 'asynchronous suspension',
    packageScheme: '',
    package: '',
    packagePath: '',
    source: '<asynchronous suspension>',
  );

  /// A stack frame representing a Dart elided stack overflow frame.
  static const StackFrame stackOverFlowElision = StackFrame(
    number: -1,
    column: -1,
    line: -1,
    method: '...',
    packageScheme: '',
    package: '',
    packagePath: '',
    source: '...',
  );

  /// Parses a list of [StackFrame]s from a [StackTrace] object.
  ///
  /// This is normally useful with [StackTrace.current].
  static List<StackFrame> fromStackTrace(StackTrace stack) {
    return fromStackString(stack.toString());
  }

  /// Parses a list of [StackFrame]s from the [StackTrace.toString] method.
  static List<StackFrame> fromStackString(String stack) {
    return stack
        .trim()
        .split('\n')
        .where((String line) => line.isNotEmpty)
        .map(fromStackTraceLine)
        // On the Web in non-debug builds the stack trace includes the exception
        // message that precedes the stack trace itself. fromStackTraceLine will
        // return null in that case. We will skip it here.
        .whereType<StackFrame>()
        .toList();
  }

  static StackFrame? _parseWebFrame(String line) {
    if (kDebugMode) {
      return _parseWebDebugFrame(line);
    } else {
      return _parseWebNonDebugFrame(line);
    }
  }

  static StackFrame _parseWebDebugFrame(String line) {
    // This RegExp is only partially correct for flutter run/test differences.
    // https://github.com/flutter/flutter/issues/52685
    final bool hasPackage = line.startsWith('package');
    final RegExp parser = hasPackage
        ? RegExp(r'^(package.+) (\d+):(\d+)\s+(.+)$')
        : RegExp(r'^(.+) (\d+):(\d+)\s+(.+)$');
    Match? match = parser.firstMatch(line);
    assert(match != null, 'Expected $line to match $parser.');
    match = match!;

    String package = '<unknown>';
    String packageScheme = '<unknown>';
    String packagePath = '<unknown>';
    if (hasPackage) {
      packageScheme = 'package';
      final Uri packageUri = Uri.parse(match.group(1)!);
      package = packageUri.pathSegments[0];
      packagePath = packageUri.path.replaceFirst('${packageUri.pathSegments[0]}/', '');
    }

    return StackFrame(
      number: -1,
      packageScheme: packageScheme,
      package: package,
      packagePath: packagePath,
      line: int.parse(match.group(2)!),
      column: int.parse(match.group(3)!),
      className: '<unknown>',
      method: match.group(4)!,
      source: line,
    );
  }

  // Non-debug builds do not point to dart code but compiled JavaScript, so
  // line numbers are meaningless. We only attempt to parse the class and
  // method name, which is more or less readable in profile builds, and
  // minified in release builds.
  static final RegExp _webNonDebugFramePattern = RegExp(r'^\s*at ([^\s]+).*$');

  // Parses `line` as a stack frame in profile and release Web builds. If not
  // recognized as a stack frame, returns null.
  static StackFrame? _parseWebNonDebugFrame(String line) {
    final Match? match = _webNonDebugFramePattern.firstMatch(line);
    if (match == null) {
      // On the Web in non-debug builds the stack trace includes the exception
      // message that precedes the stack trace itself. Example:
      //
      // TypeError: Cannot read property 'hello$0' of null
      //    at _GalleryAppState.build$1 (http://localhost:8080/main.dart.js:149790:13)
      //    at StatefulElement.build$0 (http://localhost:8080/main.dart.js:129138:37)
      //    at StatefulElement.performRebuild$0 (http://localhost:8080/main.dart.js:129032:23)
      //
      // Instead of crashing when a line is not recognized as a stack frame, we
      // return null. The caller, such as fromStackString, can then just skip
      // this frame.
      return null;
    }

    final List<String> classAndMethod = match.group(1)!.split('.');
    final String className = classAndMethod.length > 1 ? classAndMethod.first : '<unknown>';
    final String method = classAndMethod.length > 1
      ? classAndMethod.skip(1).join('.')
      : classAndMethod.single;

    return StackFrame(
      number: -1,
      packageScheme: '<unknown>',
      package: '<unknown>',
      packagePath: '<unknown>',
      line: -1,
      column: -1,
      className: className,
      method: method,
      source: line,
    );
  }

  /// Parses a single [StackFrame] from a single line of a [StackTrace].
  static StackFrame? fromStackTraceLine(String line) {
    if (line == '<asynchronous suspension>') {
      return asynchronousSuspension;
    } else if (line == '...') {
      return stackOverFlowElision;
    }

    assert(
      line != '===== asynchronous gap ===========================',
      'Got a stack frame from package:stack_trace, where a vm or web frame was expected. '
      'This can happen if FlutterError.demangleStackTrace was not set in an environment '
      'that propagates non-standard stack traces to the framework, such as during tests.',
    );

    // Web frames.
    if (!line.startsWith('#')) {
      return _parseWebFrame(line);
    }

    final RegExp parser = RegExp(r'^#(\d+) +(.+) \((.+?):?(\d+){0,1}:?(\d+){0,1}\)$');
    Match? match = parser.firstMatch(line);
    assert(match != null, 'Expected $line to match $parser.');
    match = match!;

    bool isConstructor = false;
    String className = '';
    String method = match.group(2)!.replaceAll('.<anonymous closure>', '');
    if (method.startsWith('new')) {
      final List<String> methodParts = method.split(' ');
      // Sometimes a web frame will only read "new" and have no class name.
      className = methodParts.length > 1 ? method.split(' ')[1] : '<unknown>';
      method = '';
      if (className.contains('.')) {
        final List<String> parts  = className.split('.');
        className = parts[0];
        method = parts[1];
      }
      isConstructor = true;
    } else if (method.contains('.')) {
      final List<String> parts = method.split('.');
      className = parts[0];
      method = parts[1];
    }

    final Uri packageUri = Uri.parse(match.group(3)!);
    String package = '<unknown>';
    String packagePath = packageUri.path;
    if (packageUri.scheme == 'dart' || packageUri.scheme == 'package') {
      package = packageUri.pathSegments[0];
      packagePath = packageUri.path.replaceFirst('${packageUri.pathSegments[0]}/', '');
    }

    return StackFrame(
      number: int.parse(match.group(1)!),
      className: className,
      method: method,
      packageScheme: packageUri.scheme,
      package: package,
      packagePath: packagePath,
      line: match.group(4) == null ? -1 : int.parse(match.group(4)!),
      column: match.group(5) == null ? -1 : int.parse(match.group(5)!),
      isConstructor: isConstructor,
      source: line,
    );
  }

  /// The original source of this stack frame.
  final String source;

  /// The zero-indexed frame number.
  ///
  /// This value may be -1 to indicate an unknown frame number.
  final int number;

  /// The scheme of the package for this frame, e.g. "dart" for
  /// dart:core/errors_patch.dart or "package" for
  /// package:flutter/src/widgets/text.dart.
  ///
  /// The path property refers to the source file.
  final String packageScheme;

  /// The package for this frame, e.g. "core" for
  /// dart:core/errors_patch.dart or "flutter" for
  /// package:flutter/src/widgets/text.dart.
  final String package;

  /// The path of the file for this frame, e.g. "errors_patch.dart" for
  /// dart:core/errors_patch.dart or "src/widgets/text.dart" for
  /// package:flutter/src/widgets/text.dart.
  final String packagePath;

  /// The source line number.
  final int line;

  /// The source column number.
  final int column;

  /// The class name, if any, for this frame.
  ///
  /// This may be null for top level methods in a library or anonymous closure
  /// methods.
  final String className;

  /// The method name for this frame.
  ///
  /// This will be an empty string if the stack frame is from the default
  /// constructor.
  final String method;

  /// Whether or not this was thrown from a constructor.
  final bool isConstructor;

  @override
  int get hashCode => Object.hash(number, package, line, column, className, method, source);

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is StackFrame
        && other.number == number
        && other.package == package
        && other.line == line
        && other.column == column
        && other.className == className
        && other.method == method
        && other.source == source;
  }

  @override
  String toString() => '${objectRuntimeType(this, 'StackFrame')}(#$number, $packageScheme:$package/$packagePath:$line:$column, className: $className, method: $method)';
}

/// Framework code should use this method in favor of calling `toString` on
/// [Object.runtimeType].
///
/// Calling `toString` on a runtime type is a non-trivial operation that can
/// negatively impact performance. If asserts are enabled, this method will
/// return `object.runtimeType.toString()`; otherwise, it will return the
/// [optimizedValue], which must be a simple constant string.
String objectRuntimeType(Object? object, String optimizedValue) {
  assert(() {
    optimizedValue = object.runtimeType.toString();
    return true;
  }());
  return optimizedValue;
}

// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// A constant that is true if the application was compiled in release mode.
///
/// More specifically, this is a constant that is true if the application was
/// compiled in Dart with the '-Ddart.vm.product=true' flag.
///
/// Since this is a const value, it can be used to indicate to the compiler that
/// a particular block of code will not be executed in release mode, and hence
/// can be removed.
///
/// Generally it is better to use [kDebugMode] or `assert` to gate code, since
/// using [kReleaseMode] will introduce differences between release and profile
/// builds, which makes performance testing less representative.
///
/// See also:
///
///  * [kDebugMode], which is true in debug builds.
///  * [kProfileMode], which is true in profile builds.
const bool kReleaseMode = bool.fromEnvironment('dart.vm.product');

/// A constant that is true if the application was compiled in profile mode.
///
/// More specifically, this is a constant that is true if the application was
/// compiled in Dart with the '-Ddart.vm.profile=true' flag.
///
/// Since this is a const value, it can be used to indicate to the compiler that
/// a particular block of code will not be executed in profile mode, an hence
/// can be removed.
///
/// See also:
///
///  * [kDebugMode], which is true in debug builds.
///  * [kReleaseMode], which is true in release builds.
const bool kProfileMode = bool.fromEnvironment('dart.vm.profile');

/// A constant that is true if the application was compiled in debug mode.
///
/// More specifically, this is a constant that is true if the application was
/// not compiled with '-Ddart.vm.product=true' and '-Ddart.vm.profile=true'.
///
/// Since this is a const value, it can be used to indicate to the compiler that
/// a particular block of code will not be executed in debug mode, and hence
/// can be removed.
///
/// An alternative strategy is to use asserts, as in:
///
/// ```dart
/// assert(() {
///   // ...debug-only code here...
///   return true;
/// }());
/// ```
///
/// See also:
///
///  * [kReleaseMode], which is true in release builds.
///  * [kProfileMode], which is true in profile builds.
const bool kDebugMode = !kReleaseMode && !kProfileMode;

/// The epsilon of tolerable double precision error.
///
/// This is used in various places in the framework to allow for floating point
/// precision loss in calculations. Differences below this threshold are safe to
/// disregard.
const double precisionErrorTolerance = 1e-10;

/// A constant that is true if the application was compiled to run on the web.
///
/// See also:
///
/// * [defaultTargetPlatform], which is used by themes to find out which
///   platform the application is running on (or, in the case of a web app,
///   which platform the application's browser is running in). Can be overridden
///   in tests with [debugDefaultTargetPlatformOverride].
/// * [dart:io.Platform], a way to find out the browser's platform that is not
///   overridable in tests.
const bool kIsWeb = bool.fromEnvironment('dart.library.js_util');
