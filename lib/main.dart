import 'dart:async';

import 'package:ecommerce_app_miki/src/app.dart';
import 'package:ecommerce_app_miki/src/features/cart/application/cart_sync_service.dart';
import 'package:ecommerce_app_miki/src/features/cart/data/local/local_cart_repo.dart';
import 'package:ecommerce_app_miki/src/features/cart/data/remote/fake_remote_cart_repo.dart';
import 'package:ecommerce_app_miki/src/features/cart/data/remote/remote_cart_repo.dart';
import 'package:ecommerce_app_miki/src/features/cart/data/sembast_cart_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    usePathUrlStrategy();

    /// trick to access async provider in a synchronous way
    final localCartRepo = await SembastCartRepo.makeDefault();

    /// * Create ProviderContainer with any required overrides
    final container = ProviderContainer(
      overrides: [
        localCartRepoProvider.overrideWithValue(localCartRepo),
        remoteCartRepoProvider.overrideWithValue(FakeRemoteCartRepository()),
      ],
    );

    /// * Initialize CartSyncService to start the listener
    container.read(cartSyncServiceProvider);

    runApp(
      UncontrolledProviderScope(
        container: container,
        child: const MyApp(),
      ),
    );

    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
    };

    ErrorWidget.builder = (FlutterErrorDetails details) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text('An error occurred'),
        ),
        body: Center(child: Text(details.toString())),
      );
    };
  }, (Object error, StackTrace stack) {
    // * Log any errors to console
    debugPrint(error.toString());
  });
}
