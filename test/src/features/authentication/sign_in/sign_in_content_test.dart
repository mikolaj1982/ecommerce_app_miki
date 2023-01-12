import 'package:ecommerce_app_miki/src/features/authentication/sign_in/sign_in_form_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';
import '../auth_robot.dart';

void main() {
  const testEmail = 'test@test.com';
  const testPassword = 'test123';
  late MockAuthRepository authRepository;
  setUp(() {
    authRepository = MockAuthRepository();
  });

  group('sign in', () {
    testWidgets('''
        Given formType is signIn
        When tap on the sign-in button
        Then signInWithEmailAndPassword is not called
        ''', (tester) async {
      final r = AuthRobot(tester: tester);
      await r.pumpSignInScreen(
        authRepository: authRepository,
        formType: SignInFormType.signIn,
      );
      await r.submit();
      verifyNever(
        () => authRepository.signInWithEmailAndPassword(any(), any()),
      );
    });

    testWidgets('''
        Given formType is signIn
        When email field and password field are not empty
        When tap on the sign-in button
        Then signInWithEmailAndPassword is called once
        and onSignedInCallback is called once
        ''', (tester) async {
      final r = AuthRobot(tester: tester);
      var didSignIn = false;

      /// added to check if callback been called in widget test
      when(() => authRepository.signInWithEmailAndPassword(
            testEmail,
            testPassword,
          )).thenAnswer((_) => Future.value());
      await r.pumpSignInScreen(
          authRepository: authRepository, formType: SignInFormType.signIn, callback: () => didSignIn = true);
      await r.enterEmail(testEmail);
      await r.enterPassword(testPassword);
      await r.submit();
      verify(() => authRepository.signInWithEmailAndPassword(
            testEmail,
            testPassword,
          )).called(1);
      r.expectErrorAlertNotFound();
      expect(didSignIn, true);
    });
  });

  group('register', () {
    testWidgets('''
        Given formType is register
        When tap on the sign-in button
        Then createUserWithEmailAndPassword is not called
        ''', (tester) async {
      final r = AuthRobot(tester: tester);
      await r.pumpSignInScreen(
        authRepository: authRepository,
        formType: SignInFormType.register,
      );
      await r.submit();
      verifyNever(
        () => authRepository.createUserWithEmailAndPassword(any(), any()),
      );
    });

    testWidgets('''
        Given formType is register
        When email field and password field are not empty
        When tap on the sign-in button
        Then createUserWithEmailAndPassword is called once
        and onSignedInCallback is called once
        ''', (tester) async {
      final r = AuthRobot(tester: tester);
      var didSignIn = false;

      /// added to check if callback been called in widget test
      when(() => authRepository.createUserWithEmailAndPassword(
            testEmail,
            testPassword,
          )).thenAnswer((_) => Future.value());
      await r.pumpSignInScreen(
          authRepository: authRepository, formType: SignInFormType.register, callback: () => didSignIn = true);
      await r.enterEmail(testEmail);
      await r.enterPassword(testPassword);
      await r.submit();
      verify(() => authRepository.createUserWithEmailAndPassword(
            testEmail,
            testPassword,
          )).called(1);
      r.expectErrorAlertNotFound();
      expect(didSignIn, true);
    });
  });

  group('updateFormType', () {
    testWidgets('''
        Given formType is signIn
        When tap on the Register button
        Then the formType is changed to register
        Then create account button is found
        ''', (tester) async {
      final r = AuthRobot(tester: tester);
      await r.pumpSignInScreen(
        formType: SignInFormType.signIn,
      );
      await r.tapFormToggleButton();
      r.expectCreateAccountButtonFound();
    });

    testWidgets('''
        Given formType is register
        When tap on the form toggle button
        Then create account button is not found
        ''', (tester) async {
      final r = AuthRobot(tester: tester);
      await r.pumpSignInScreen(
        formType: SignInFormType.register,
      );
      await r.tapFormToggleButton();
      r.expectCreateAccountButtonNotFound();
    });
  });
}
