import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_exception.dart';

class ErrorLogger {
  void logError(Object error, StackTrace? stackTrace) {
    // this can be replaced with a call to a crash reporting tool of choice
    debugPrint('$error, $stackTrace');
  }

  void logAppException(AppException exception) {
    // this can be replaced with a call to a crash reporting tool of choice
    debugPrint('$exception');
  }
}

final errorLoggerProvider = Provider<ErrorLogger>(
  (ref) => ErrorLogger(),
);
