import 'package:ecommerce_app_miki/src/app.dart';
import 'package:ecommerce_app_miki/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app_miki/src/features/cart/application/cart_sync_service.dart';
import 'package:ecommerce_app_miki/src/features/cart/data/local/fake_local_cart_repo.dart';
import 'package:ecommerce_app_miki/src/features/cart/data/local/local_cart_repo.dart';
import 'package:ecommerce_app_miki/src/features/cart/data/remote/fake_remote_cart_repo.dart';
import 'package:ecommerce_app_miki/src/features/cart/data/remote/remote_cart_repo.dart';
import 'package:ecommerce_app_miki/src/features/home_app_bar/more_menu_button.dart';
import 'package:ecommerce_app_miki/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_app_miki/src/features/products/providers/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'features/authentication/auth_robot.dart';
import 'features/cart/cart_robot.dart';
import 'features/products/product_robot.dart';
import 'goldens/golden_robot.dart';

class Robot {
  final WidgetTester tester;
  final AuthRobot authRobot;
  final ProductRobot productRobot;
  final GoldenRobot goldenRobot;
  final CartRobot cartRobot;

  Robot({required this.tester})
      : authRobot = AuthRobot(tester: tester),
        productRobot = ProductRobot(tester: tester),
        cartRobot = CartRobot(tester: tester),
        goldenRobot = GoldenRobot(tester: tester);

  Future<void> pumpMyApp() async {
    final productsRepository = FakeProductsRepository(addDelay: false);
    final authRepository = FakeAuthRepository(addDelay: false);
    final localCartRepository = FakeLocalCartRepository(addDelay: false);
    final remoteCartRepository = FakeRemoteCartRepository(addDelay: false);

    final container = ProviderContainer(
      overrides: [
        productsRepoProvider.overrideWithValue(productsRepository),
        authRepositoryProvider.overrideWithValue(authRepository),
        localCartRepoProvider.overrideWithValue(localCartRepository),
        remoteCartRepoProvider.overrideWithValue(remoteCartRepository),
      ],
    );

    // * Initialize CartSyncService to start the listener
    container.read(cartSyncServiceProvider);
    // * Entry point of the app

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MyApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> openPopupMenu() async {
    final popUpBtn = find.byType(MoreMenuButton);
    final matches = popUpBtn.evaluate();

    /// if an item is found, it means that we are running
    /// on a small window and can tap the reveal the menu
    if (matches.isNotEmpty) {
      debugPrint('MoreMenuButton clicked');
      await tester.tap(popUpBtn);
      await tester.pumpAndSettle();
    }

    /// else no-op, as the items are already visible
  }

  Future<void> openAccountScreen() async {
    final goToAccountScreenBtn = find.byKey(MoreMenuButton.accountKey);
    expect(goToAccountScreenBtn, findsOneWidget);
    await tester.tap(goToAccountScreenBtn);
    await tester.pumpAndSettle();
  }

  Future<void> goBack() async {
    final finder = find.byTooltip('Back');
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> closePage() async {
    final finder = find.byTooltip('Close');
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }
}
