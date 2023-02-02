import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/src/robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // testWidgets('Add two products with quantity = 1', (tester) async {
  //   await tester.runAsync(() async {
  //     final r = Robot(tester: tester);
  //     await r.pumpMyApp();
  //     await addDelay();
  //     await r.productRobot.scrollToProduct();
  //     await addDelay();
  //     await r.productRobot.selectProduct(); // price 15
  //     await addDelay();
  //     await r.cartRobot.addToCartButton();
  //     await addDelay();
  //     await r.goBack();
  //     await addDelay();
  //     await r.productRobot.scrollToProduct(atIndex: 13);
  //     await addDelay();
  //     await r.productRobot.selectProduct(atIndex: 13); // price 14
  //     await addDelay();
  //     await r.cartRobot.addToCartButton();
  //     await addDelay();
  //     await r.cartRobot.openCart();
  //     await addDelay();
  //     r.cartRobot.expectItemQuantity(quantity: 1, atIndex: 0);
  //     r.cartRobot.expectItemQuantity(quantity: 1, atIndex: 1);
  //     r.cartRobot.expectFindTotalPrice('Total: \$31.00');
  //     await addDelay();
  //   });
  // });

  // testWidgets('Sign in and sign out flow', (tester) async {
  //   await tester.runAsync(() async {
  //     final r = Robot(tester: tester);
  //     await r.pumpMyApp();
  //     await addDelay();
  //     await r.productRobot.selectProduct();
  //     await addDelay();
  //     await r.productRobot.setProductQuantity(5);
  //     await addDelay();
  //     await r.cartRobot.addToCartButton();
  //     await addDelay();
  //     await r.cartRobot.openCart();
  //     await addDelay();
  //     r.cartRobot.expectItemQuantity(quantity: 5, atIndex: 0);
  //     await addDelay();
  //     r.cartRobot.expectFindTotalPrice('Total: \$75.00');
  //     await addDelay();
  //   });
  // });

  // testWidgets('Add product with quantity = 2, then increment by 2', (tester) async {
  //   await tester.runAsync(() async {
  //     const quantity = 2;
  //     final r = Robot(tester: tester);
  //     await r.pumpMyApp();
  //     await addDelay();
  //     await r.productRobot.selectProduct();
  //     await addDelay();
  //     await r.productRobot.setProductQuantity(quantity);
  //     await addDelay();
  //     await r.cartRobot.addToCartButton();
  //     await addDelay();
  //     await r.cartRobot.openCart();
  //     await addDelay();
  //     await r.cartRobot.incrementQuantityButton(quantity: 2, atIndex: 0);
  //     await addDelay();
  //     r.cartRobot.expectItemQuantity(quantity: 4, atIndex: 0);
  //     r.cartRobot.expectFindTotalPrice('Total: \$60.00');
  //   });
  // });

  testWidgets('Add product, then delete it', (tester) async {
    await tester.runAsync(() async {
      final r = Robot(tester: tester);
      await r.pumpMyApp();
      await addDelay();
      await r.productRobot.selectProduct();
      // await addDelay();
      // await r.productRobot.scrollToProduct();
      await addDelay();
      await r.cartRobot.addToCartButton();
      await addDelay();
      await r.cartRobot.openCart();
      await addDelay();
      await r.cartRobot.deleteItemButton(atIndex: 0);
      await addDelay();
      r.cartRobot.expectFindEmptyCart();
    });
  });

}

Future<void> addDelay() async {
  await Future<void>.delayed(const Duration(seconds: 1));
}
