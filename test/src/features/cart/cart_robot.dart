import 'package:ecommerce_app_miki/src/common_widgets/item_quantity_selector.dart';
import 'package:ecommerce_app_miki/src/features/cart/presentation/shopping_cart_item.dart';
import 'package:ecommerce_app_miki/src/features/home_app_bar/shopping_cart_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class CartRobot {
  final WidgetTester tester;

  CartRobot({required this.tester});

  // shopping cart
  Future<void> openCart() async {
    final finder = find.byKey(ShoppingCartIcon.shoppingCartIconKey);
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  void expectFindEmptyCart() {
    final finder = find.text('Your cart is empty');
    expect(finder, findsOneWidget);
  }

  Future<void> addToCartButton() async {
    final finder = find.text('Add to Cart');
    expect(finder, findsOneWidget);
    await tester.tap(finder, warnIfMissed: false);
    await tester.pumpAndSettle();
  }

  void expectFindTotalPrice(String s) {
    final finder = find.text(s);
    expect(finder, findsOneWidget);
  }

  void expectItemQuantity({required int quantity, int? atIndex}) {
    final text = getItemQuantityWidget(atIndex: atIndex ?? 0);
    debugPrint('text.data: ${text.data}');
    expect(text.data, '$quantity');
  }

  Text getItemQuantityWidget({int? atIndex}) {
    final key = ItemQuantitySelector.quantityKey(atIndex);
    debugPrint('key: $key');

    /// => key: [<'quantity-0'>]
    final finder = find.byKey(key);
    expect(finder, findsOneWidget);
    return finder.evaluate().single.widget as Text;
  }

  Future<void> incrementQuantityButton({required int quantity, required int atIndex}) async {
    final finder = find.byKey(ItemQuantitySelector.incrementKey(atIndex));
    expect(finder, findsOneWidget);
    for (var i = 0; i < quantity; i++) {
      await tester.tap(finder);
      await tester.pumpAndSettle();
    }
  }

  Future<void> decrementQuantityButton({required int quantity, required int atIndex}) async {
    final finder = find.byKey(ItemQuantitySelector.decrementKey(atIndex));
    expect(finder, findsOneWidget);
    for (var i = 0; i < quantity; i++) {
      await tester.tap(finder);
      await tester.pumpAndSettle();
    }
  }

  Future<void> deleteItemButton({required int atIndex}) async {
    final finder = find.byKey(EditOrRemoveItemWidget.deleteKey(atIndex));
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  void expectProductIsOutOfStock() {
    final finder = find.text('Out of Stock');
    expect(finder, findsOneWidget);
  }
}
