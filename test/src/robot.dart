import 'package:ecommerce_app_miki/src/app.dart';
import 'package:ecommerce_app_miki/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app_miki/src/features/home_app_bar/more_menu_button.dart';
import 'package:ecommerce_app_miki/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_app_miki/src/features/products/providers/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'features/authentication/auth_robot.dart';
import 'features/products/product_robot.dart';
import 'goldens/golden_robot.dart';

class Robot {
  final WidgetTester tester;
  final AuthRobot authRobot;
  final ProductRobot productRobot;
  final GoldenRobot goldenRobot;

  Robot({required this.tester})
      : authRobot = AuthRobot(tester: tester),
        productRobot = ProductRobot(tester: tester),
        goldenRobot = GoldenRobot(tester: tester);

  Future<void> pumpMyApp() async {
    final productsRepository = FakeProductsRepository(addDelay: false);
    final authRepository = FakeAuthRepository(addDelay: false);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          productsRepoProvider.overrideWithValue(productsRepository),
          authRepositoryProvider.overrideWithValue(authRepository),
        ],
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
}
