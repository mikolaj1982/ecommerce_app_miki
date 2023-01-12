import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/src/robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  /// await Future<void>.delayed(const Duration(seconds: 2));
  testWidgets('Sign in and sign out flow', (tester) async {
    await tester.runAsync(() async {
      final r = Robot(tester: tester);
      await r.pumpMyApp();
      r.productRobot.expectFindAllProductCards();
      await r.openPopupMenu();
      await r.authRobot.openEmailPasswordSignInScreen();
      await r.authRobot.tapFormToggleButton();
      await r.authRobot.enterAndSubmitEmailAndPassword();
      r.productRobot.expectFindAllProductCards();
      await r.openPopupMenu();
      await r.openAccountScreen();
      await r.authRobot.tapLogoutButton();
      await r.authRobot.tapDialogLogoutButton();
      r.productRobot.expectFindAllProductCards();
    });
  });
}
