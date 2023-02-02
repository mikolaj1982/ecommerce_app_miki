@Timeout(Duration(milliseconds: 500))
import 'package:flutter_test/flutter_test.dart';

import '../../../robot.dart';

void main() {
  group('shopping cart', () {
    // * Note: All tests are wrapped with `runAsync` to prevent this error:
    // * A Timer is still pending even after the widget tree was disposed.
    testWidgets('Empty shopping cart screen', (tester) async {
      await tester.runAsync(() async {
        final r = Robot(tester: tester);
        await r.pumpMyApp();
        r.productRobot.expectFindNProductsCards(14);
        await r.cartRobot.openCart();
        r.cartRobot.expectFindEmptyCart();
      });
    });

    testWidgets('Add product with quantity = 1 at index 0', (tester) async {
      await tester.runAsync(() async {
        const quantity = 1;
        final r = Robot(tester: tester);
        await r.pumpMyApp();
        await r.productRobot.selectProduct();
        await r.productRobot.setProductQuantity(quantity);
        await r.cartRobot.addToCartButton();
        await r.cartRobot.openCart();
        r.cartRobot.expectItemQuantity(quantity: quantity);
        r.cartRobot.expectFindTotalPrice('Total: \$15.00');
      });
    });

    testWidgets('Add product with quantity = 5 at index 1', (tester) async {
      await tester.runAsync(() async {
        const quantity = 5;
        final r = Robot(tester: tester);
        await r.pumpMyApp();

        /// price of product with index 1 is 13 hence total price is 13 * 5 = 65
        await r.productRobot.selectProduct(atIndex: 1);
        await r.productRobot.setProductQuantity(quantity);
        await r.cartRobot.addToCartButton();
        await r.cartRobot.openCart();
        r.cartRobot.expectItemQuantity(quantity: quantity);
        r.cartRobot.expectFindTotalPrice('Total: \$65.00');
      });
    });

    testWidgets('Add product with quantity = 2, then increment by 2', (tester) async {
      await tester.runAsync(() async {
        const quantity = 2;
        final r = Robot(tester: tester);
        await r.pumpMyApp();
        await r.productRobot.selectProduct();
        await r.productRobot.setProductQuantity(quantity);
        await r.cartRobot.addToCartButton();
        await r.cartRobot.openCart();
        await r.cartRobot.incrementQuantityButton(quantity: 2, atIndex: 0);
        r.cartRobot.expectItemQuantity(quantity: 4, atIndex: 0);
        r.cartRobot.expectFindTotalPrice('Total: \$60.00');
      });
    });

    testWidgets('Add product with quantity = 5, then decrement by 2', (tester) async {
      await tester.runAsync(() async {
        final r = Robot(tester: tester);
        await r.pumpMyApp();
        await r.productRobot.selectProduct();
        await r.productRobot.setProductQuantity(5);
        await r.cartRobot.addToCartButton();
        await r.cartRobot.openCart();
        await r.cartRobot.decrementQuantityButton(quantity: 2, atIndex: 0);
        r.cartRobot.expectItemQuantity(quantity: 3, atIndex: 0);
        r.cartRobot.expectFindTotalPrice('Total: \$45.00');
      });
    });

    testWidgets('Add product with quantity = 6 at index 0', (tester) async {
      await tester.runAsync(() async {
        /*
          Product(
            id: '1',
            imageUrl: 'assets/products/bruschetta-plate.jpg',
            title: 'Bruschetta plate',
            description: 'Lorem ipsum',
            price: 15,
            availableQuantity: 5,
            avgRating: 4.5,
            numRatings: 2,
        ),
         */
        const productIndex = 0;
        var quantity = 6;
        const availableQuantity = 5;
        if (quantity > availableQuantity) {
          quantity = availableQuantity;
        }
        const price = 15;
        final r = Robot(tester: tester);
        await r.pumpMyApp();
        await r.productRobot.selectProduct(atIndex: productIndex);
        await r.productRobot.setProductQuantity(quantity);
        await r.cartRobot.addToCartButton();
        await r.cartRobot.openCart();
        r.cartRobot.expectItemQuantity(quantity: quantity);
        r.cartRobot.expectFindTotalPrice('Total: \$${price * quantity}.00');
      });
    });

    testWidgets('Add two products with quantity = 1', (tester) async {
      await tester.runAsync(() async {
        final r = Robot(tester: tester);
        await r.pumpMyApp();
        await r.productRobot.selectProduct();
        await r.productRobot.scrollToProduct();
        await r.cartRobot.addToCartButton();
        await r.goBack();
        await r.productRobot.scrollToProduct(atIndex: 13);
        await r.productRobot.selectProduct(atIndex: 13); // price 14
        await r.cartRobot.addToCartButton();
        await r.cartRobot.openCart();
        r.cartRobot.expectItemQuantity(quantity: 1, atIndex: 0);
        r.cartRobot.expectItemQuantity(quantity: 1, atIndex: 1);
        r.cartRobot.expectFindTotalPrice('Total: \$31.00');
      });
    });

    testWidgets('Add product, then delete it', (tester) async {
      await tester.runAsync(() async {
        final r = Robot(tester: tester);
        await r.pumpMyApp();
        await r.productRobot.selectProduct();
        await r.productRobot.scrollToProduct();
        await r.cartRobot.addToCartButton();
        await r.cartRobot.openCart();
        await r.cartRobot.deleteItemButton(atIndex: 0);
        r.cartRobot.expectFindEmptyCart();
      });
    });

    testWidgets('Add product with quantity = 5, goes out of stock', (tester) async {
      await tester.runAsync(() async {
        final r = Robot(tester: tester);
        await r.pumpMyApp();
        await r.productRobot.selectProduct();
        await r.productRobot.setProductQuantity(5);
        await r.cartRobot.addToCartButton();
        r.cartRobot.expectProductIsOutOfStock();
      });
    });

    testWidgets('Add product with quantity = 5, remains out of stock when opened again', (tester) async {
      await tester.runAsync(() async {
        final r = Robot(tester: tester);
        await r.pumpMyApp();
        await r.productRobot.selectProduct();
        await r.productRobot.setProductQuantity(5);
        await r.cartRobot.addToCartButton();
        await r.goBack();
        await r.productRobot.selectProduct();
        r.cartRobot.expectProductIsOutOfStock();
      });
    });
  });
}
