import 'package:flutter_test/flutter_test.dart';

import '../../robot.dart';

void main() {
  testWidgets('Sign in and sign out flow', (tester) async {
    /// 1. need to open password and email screen
    /// 2. toggle form for registration
    /// 3. enter test email and test password and submit it
    /// 4. and then it should verify that the user is signed in
    /// and that it takes us back to product list
    /// 5. open the account screen
    /// 6. press on logout button
    /// 7. and then confirm that we want to logout using the dialog
    /// 8. and then verify that we are back on the product list screen
    await tester.runAsync(() async {
      final r = Robot(tester: tester);
      await r.pumpMyApp();
      r.productRobot.expectFindAllProductCards();

      // if narrow screen open MoreMenuButton
      await r.openPopupMenu();

      // open the sign in screen
      await r.authRobot.openEmailPasswordSignInScreen();

      // toggle form for registration
      await r.authRobot.tapFormToggleButton();

      // enter test email and test password and submit it
      await r.authRobot.enterAndSubmitEmailAndPassword();

      // and then it should verify that the user is signed in
      r.productRobot.expectFindAllProductCards();

      // open the account screen
      await r.openPopupMenu();
      await r.openAccountScreen();

      // press on logout button
      await r.authRobot.tapLogoutButton();

      // and then confirm that we want to logout using the dialog
      await r.authRobot.tapDialogLogoutButton();

      // and then verify that we are back on the product list screen
      r.productRobot.expectFindAllProductCards();
    });
  });
}
