import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/src/robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('checkout when previously signed in', (tester) async {
    await tester.runAsync(() async {
      final r = Robot(tester: tester);
      await r.pumpMyApp();

      /// create an account first
      await r.openPopupMenu();
      await addDelay();
      await r.authRobot.openEmailPasswordSignInScreen();
      await addDelay();
      await r.authRobot.tapFormToggleButton();
      await addDelay();
      await r.authRobot.enterAndSubmitEmailAndPassword();
      await addDelay();

      /// then add a product and start checkout
      r.productRobot.expectFindNProductsCards(14);
      await r.productRobot.selectProduct();
      await addDelay();
      await r.cartRobot.addToCartButton();
      await addDelay();
      await r.cartRobot.openCart();
      await addLongDelay();
      await r.checkoutRobot.checkoutButton();
      await addLongDelay();

      /// expect that we see the payment page right away
      r.checkoutRobot.expectPayButtonFound();
      await addDelay();
    });
  });
}

Future<void> addLongDelay() async {
  await Future<void>.delayed(const Duration(seconds: 20));
}

Future<void> addDelay() async {
  await Future<void>.delayed(const Duration(seconds: 1));
}
