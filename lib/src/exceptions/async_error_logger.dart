import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_exception.dart';
import 'error_logger.dart';

class AsyncErrorLogger extends ProviderObserver {
  @override
  void didUpdateProvider(ProviderBase provider,
      Object? previousValue,
      Object? newValue,
      ProviderContainer container,) {
    final errorLogger = container.read(errorLoggerProvider);
    final error = _findError(newValue);
    if (error != null) {
      if (error.error is AppException) {
        /// only prints the AppException data 
        errorLogger.logAppException(error.error as AppException);
      } else {
        /// prints the full error with stack trace
        errorLogger.logError(error.error, error.stackTrace);
      }
    }
  }

  AsyncError<dynamic>? _findError(Object? value) {
    if (value is AsyncError) {
      return value;
    } else {
      return null;
    }
  }
}
