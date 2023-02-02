import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/src/robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Add product, then delete it', (tester) async {
    await tester.runAsync(() async {
      final r = Robot(tester: tester);
      await r.pumpMyApp();

      /// add cart flows
      await r.productRobot.selectProduct();
      await addDelay();
      await r.productRobot.setProductQuantity(2);
      await addDelay();
      await r.cartRobot.addToCartButton();
      await addDelay();
      await r.cartRobot.openCart();
      await addDelay();
      r.cartRobot.expectItemQuantity(quantity: 2, atIndex: 0);
      await r.closePage();
      await addDelay();

      /// sign in
      await r.openPopupMenu();
      await addDelay();
      await r.authRobot.openEmailPasswordSignInScreen();
      await addDelay();
      await r.authRobot.tapFormToggleButton();
      await addDelay();
      await r.authRobot.enterAndSubmitEmailAndPassword();
      await addDelay();
      r.productRobot.expectFindAllProductCards();

      /// check cart again (to verify synchronization)
      await r.cartRobot.openCart();
      await addDelay();
      r.cartRobot.expectItemQuantity(quantity: 2, atIndex: 0);
      await r.closePage();
      await addDelay();

      /// sign out
      await r.openPopupMenu();
      await addDelay();
      await r.openAccountScreen();
      await addDelay();
      await r.authRobot.tapLogoutButton();
      await addDelay();
      await r.authRobot.tapDialogLogoutButton();
      await addDelay();
      r.productRobot.expectFindAllProductCards();
    });
  });

}

Future<void> addDelay() async {
  await Future<void>.delayed(const Duration(seconds: 1));
}
