import 'package:ecommerce_app_miki/src/constants/test_products.dart';
import 'package:ecommerce_app_miki/src/features/products/product_list/products_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class ProductRobot {
  final WidgetTester tester;

  ProductRobot({required this.tester});

  void expectFindAllProductCards() {
    expect(find.byType(ProductCard), findsNWidgets(testProducts.length));
  }

  void expectFindNProductsCards(int count) {
    expect(find.byType(ProductCard), findsNWidgets(count));
  }

  // products list
  Future<void> selectProduct({int atIndex = 0}) async {
    final finder = find.byType(ProductCard);
    if (finder.evaluate().isNotEmpty) {
      await tester.tap(finder.at(atIndex), warnIfMissed: false);
      await tester.pumpAndSettle();
    }
  }

  Future<void> scrollToProduct({int atIndex = 0}) async {
    final expectedWidget = find.byKey(ProductCard.productCardKey(atIndex));
    if (expectedWidget.evaluate().isNotEmpty) {
      await tester.dragUntilVisible(
        expectedWidget, // what you want to find
        find.byType(SingleChildScrollView), // widget you want to scroll
        const Offset(0, 50), // delta to move
      );

      await tester.tap(expectedWidget, warnIfMissed: false);
      await tester.pumpAndSettle();
    }
  }

  Future<void> setProductQuantity(int quantity) async {
    final finder = find.byIcon(Icons.add);
    expect(finder, findsOneWidget);
    for (var i = 1; i < quantity; i++) {
      await tester.tap(finder);
      await tester.pumpAndSettle();
    }
  }
}
