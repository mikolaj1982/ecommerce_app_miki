import 'package:ecommerce_app_miki/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app_miki/src/features/authentication/domain/app_user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';
import '../auth_robot.dart';

void main() {
  testWidgets('Cancel logout', (WidgetTester tester) async {
    final r = AuthRobot(tester: tester);
    await r.pumpAccountScreen();
    await r.tapLogoutButton();
    r.expectLogoutDialogFound();
    await r.tapCancelButton();
    r.expectLogoutDialogNotFound();
  });

  testWidgets('Confirm logout, success', (WidgetTester tester) async {
    final r = AuthRobot(tester: tester);
    final authRepository = FakeAuthRepository(addDelay: false);
    await r.pumpAccountScreen(authRepository: authRepository);
    await r.tapLogoutButton();
    r.expectLogoutDialogFound();
    await r.tapDialogLogoutButton();
    r.expectLogoutDialogNotFound();
    r.expectErrorAlertNotFound();
  });

  testWidgets('Confirm logout, failure', (WidgetTester tester) async {
    final r = AuthRobot(tester: tester);
    final authRepository = MockAuthRepository();
    final exception = Exception('SignOut failed');
    when(authRepository.signOut).thenThrow(exception);
    when(authRepository.authStateChanges).thenAnswer(
      (_) => Stream.value(
        const AppUser(uid: '123', email: 'test@test.com'),
      ),
    );
    await r.pumpAccountScreen(authRepository: authRepository);
    await r.tapLogoutButton();
    r.expectLogoutDialogFound();
    await r.tapDialogLogoutButton();
    r.expectErrorAlertFound();
  });

  /// CircularProgressIndicator is present while sign out is in progress
  testWidgets(
    'Confirm logout, in progress',
    (WidgetTester tester) async {
      final r = AuthRobot(tester: tester);
      final authRepository = MockAuthRepository();
      when(authRepository.signOut).thenAnswer(
        (_) => Future.delayed(const Duration(seconds: 1)),
      );
      when(authRepository.authStateChanges).thenAnswer(
        (_) => Stream.value(
          const AppUser(uid: '123', email: 'test@test.com'),
        ),
      );
      await r.pumpAccountScreen(authRepository: authRepository);
      await tester.runAsync(() async {
        await r.tapLogoutButton();
        r.expectLogoutDialogFound();
        await r.tapDialogLogoutButton();
      });

      r.expectCircularProgressIndicatorFound();
    },
  );
}
