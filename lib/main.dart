import 'dart:async';
import 'dart:ui';

import 'package:ecommerce_app_miki/src/app.dart';
import 'package:ecommerce_app_miki/src/exceptions/async_error_logger.dart';
import 'package:ecommerce_app_miki/src/exceptions/error_logger.dart';
import 'package:ecommerce_app_miki/src/features/cart/application/cart_sync_service.dart';
import 'package:ecommerce_app_miki/src/features/cart/application/wish_list_service.dart';
import 'package:ecommerce_app_miki/src/features/cart/data/local/local_cart_repo.dart';
import 'package:ecommerce_app_miki/src/features/cart/data/remote/fake_remote_cart_repo.dart';
import 'package:ecommerce_app_miki/src/features/cart/data/remote/remote_cart_repo.dart';
import 'package:ecommerce_app_miki/src/features/cart/data/sembast_cart_repo.dart';
import 'package:ecommerce_app_miki/src/features/cart/data/sembast_wish_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

/// Errors vs Exceptions
/// error is a programmer mistake that needs to be fix for example:
/// - calling a method with wrong number of arguments
/// - calling a method on null
/// - access list of index out of bounds
/// - accessing a property on null
/// - accessing a property that doesn't exist
/// need to be fixed by fixing the code
/// these are fatal errors can not be recovered from
///
///
/// Exception is a failure condition that something unexpected happened
/// something out of out control
/// connection error
/// authentication fil sign in with wrong credentials
/// payment failed like putting incorrect card details
/// we should present an error message and resume programme with info for the user
/// app have to resume normally non-fatal errors we should recover from

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();

  /// trick to access async provider in a synchronous way
  final localCartRepo = await SembastCartRepo.makeDefault();
  final localWishListRepo = await SembastWishListRepo.makeDefault();

  /// * Create ProviderContainer with any required overrides
  final container = ProviderContainer(
    overrides: [
      localCartRepoProvider.overrideWithValue(localCartRepo),
      remoteCartRepoProvider.overrideWithValue(FakeRemoteCartRepository()),
      sembastWishListRepoProvider.overrideWithValue(localWishListRepo),
    ],
    observers: [
      AsyncErrorLogger(),
    ],
  );

  /// * Initialize CartSyncService to start the listener
  container.read(cartSyncServiceProvider);

  final errorLogger = container.read(errorLoggerProvider);
  registerErrorHandlers(errorLogger);

  runApp(UncontrolledProviderScope(
    container: container,
    child: const MyApp(),
  ));
}

void registerErrorHandlers(ErrorLogger errorLogger) {
  // * Show some error UI if any uncaught exception happens
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    errorLogger.logError(details.exception, details.stack);
  };
  // * Handle errors from the underlying platform/OS
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    errorLogger.logError(error, stack);
    return true;
  };
  // * Show some error UI when any widget in the app fails to build
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('An error occurred'),
      ),
      body: Center(child: Text(details.toString())),
    );
  };
}
