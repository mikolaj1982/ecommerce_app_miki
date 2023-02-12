import 'package:ecommerce_app_miki/src/constants/test_products.dart';
import 'package:ecommerce_app_miki/src/features/cart/presentation/shopping_cart_screen.dart';
import 'package:ecommerce_app_miki/src/features/products/product_list/products_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class CheckoutRobot {
  final WidgetTester tester;

  CheckoutRobot({required this.tester});

  Future<void> checkoutButton() async {
    // await tester.ensureVisible(find.byKey(const Key('checkoutButtonKey')));
    final finder = find.byKey(ShoppingCartScreen.checkoutButtonKey);
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  void expectPayButtonFound() {
    final finder = find.text('Pay');
    expect(finder, findsOneWidget);
  }
}
