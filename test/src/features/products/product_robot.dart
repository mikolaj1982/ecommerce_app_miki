import 'package:ecommerce_app_miki/src/constants/test_products.dart';
import 'package:ecommerce_app_miki/src/features/products/product_list/products_card.dart';
import 'package:flutter_test/flutter_test.dart';

class ProductRobot {
  final WidgetTester tester;

  ProductRobot({required this.tester});

  void expectFindAllProductCards() {
    expect(find.byType(ProductCard), findsNWidgets(testProducts.length));
  }
}
