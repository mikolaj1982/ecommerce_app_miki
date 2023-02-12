import 'package:flutter_test/flutter_test.dart';

import '../../robot.dart';

void main() {
  testWidgets('checkout when not previously signed in', (tester) async {
    await tester.runAsync(() async {
      final r = Robot(tester: tester);
      await r.pumpMyApp();
      r.productRobot.expectFindNProductsCards(14);
      await r.productRobot.selectProduct();
      await r.cartRobot.addToCartButton();
      await r.cartRobot.openCart();
      await r.checkoutRobot.checkoutButton();
      // sign in from checkout screen
      r.authRobot.expectEmailAndPasswordFieldsFound();
      await r.authRobot.enterAndSubmitEmailAndPassword();
      r.checkoutRobot.expectPayButtonFound();
    });
  });

  testWidgets('checkout when previously signed in', (tester) async {
    // await tester.runAsync(() async {
      final r = Robot(tester: tester);
      await r.pumpMyApp();

      // create an account first
      await r.openPopupMenu();
      await r.authRobot.openEmailPasswordSignInScreen();
      await r.authRobot.tapFormToggleButton();
      await r.authRobot.enterAndSubmitEmailAndPassword();

      // then add a product and start checkout
      r.productRobot.expectFindNProductsCards(14);
      await r.productRobot.selectProduct();
      await r.cartRobot.addToCartButton();
      await r.cartRobot.openCart();
      await r.checkoutRobot.checkoutButton();

      // expect that we see the payment page right away
      r.checkoutRobot.expectPayButtonFound();
    });
  // });

}
