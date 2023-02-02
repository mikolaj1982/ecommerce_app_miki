import 'package:ecommerce_app_miki/src/common_widgets/alert_dialogs.dart';
import 'package:ecommerce_app_miki/src/common_widgets/custom_text_button.dart';
import 'package:ecommerce_app_miki/src/common_widgets/primary_button.dart';
import 'package:ecommerce_app_miki/src/features/authentication/account/account_screen.dart';
import 'package:ecommerce_app_miki/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app_miki/src/features/authentication/sign_in/sign_in_content.dart';
import 'package:ecommerce_app_miki/src/features/authentication/sign_in/sign_in_form_type.dart';
import 'package:ecommerce_app_miki/src/features/home_app_bar/more_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class AuthRobot {
  final WidgetTester tester;

  AuthRobot({required this.tester});

  /// check when the logout button is pressed the popup is displayed and when cancelled popup disappeared
  Future<void> pumpAccountScreen({FakeAuthRepository? authRepository}) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          if (authRepository != null) authRepositoryProvider.overrideWithValue(authRepository),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: AccountScreen(),
          ),
        ),
      ),
    );
  }

  Future<void> openEmailPasswordSignInScreen() async {
    final goToSignInScreenBtn = find.byKey(MoreMenuButton.signInKey);
    expect(goToSignInScreenBtn, findsOneWidget);
    await tester.tap(goToSignInScreenBtn);

    /// correct to use when we have page transitions
    await tester.pumpAndSettle();
  }

  Future<void> enterAndSubmitEmailAndPassword() async {
    await enterEmail('test@test.com');
    await enterPassword('kupa123');
    await submit();
  }

  Future<void> enterEmail(String testEmail) async {
    final emailField = find.byKey(EmailPasswordSignInContents.emailKey);
    expect(emailField, findsOneWidget);
    await tester.enterText(emailField, testEmail);
  }

  Future<void> enterPassword(String testPassword) async {
    final passwordField = find.byKey(EmailPasswordSignInContents.passwordKey);
    expect(passwordField, findsOneWidget);
    await tester.enterText(passwordField, testPassword);
  }

  Future<void> pumpSignInScreen(
      {FakeAuthRepository? authRepository, required SignInFormType formType, VoidCallback? callback}) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          if (authRepository != null) authRepositoryProvider.overrideWithValue(authRepository),
        ],
        child: MaterialApp(
          home: EmailPasswordSignInContents(
            formType: formType,
            onSignedIn: callback,
          ),
        ),
      ),
    );
  }

  Future<void> submit() async {
    debugPrint('PrimaryButton clicked');
    final signInBtn = find.byType(PrimaryButton);
    expect(signInBtn, findsOneWidget);
    await tester.tap(signInBtn);
    await tester.pumpAndSettle();
  }

  Future<void> tapLogoutButton() async {
    final logoutBtn = find.text('Logout');
    expect(logoutBtn, findsOneWidget);
    await tester.tap(logoutBtn);

    /// the test environment does not update the UI after we perform an interaction (e.g. top a button)
    /// we need to manually pump the widget tree to update the UI
    await tester.pump();
  }

  Future<void> tapDialogLogoutButton() async {
    final logoutBtn = find.byKey(kDialogDefaultKey);
    expect(logoutBtn, findsOneWidget);
    await tester.tap(logoutBtn);
    await tester.pumpAndSettle();
  }

  void expectLogoutDialogFound() {
    final dialogTitle = find.text('Are you sure?');
    expect(dialogTitle, findsOneWidget);
  }

  Future<void> tapCancelButton() async {
    final cancelBtn = find.text('Cancel');
    expect(cancelBtn, findsOneWidget);
    await tester.tap(cancelBtn);
    await tester.pump();
  }

  void expectLogoutDialogNotFound() {
    final dialogTitle = find.text('Are you sure?');
    expect(dialogTitle, findsNothing);
  }

  void expectErrorAlertFound() {
    final finder = find.byType(SnackBar);
    expect(finder, findsOneWidget);
  }

  void expectErrorAlertNotFound() {
    final finder = find.byType(SnackBar);
    expect(finder, findsNothing);
  }

  void expectCircularProgressIndicatorFound() {
    final finder = find.byType(CircularProgressIndicator);
    expect(finder, findsOneWidget);
  }

  Future<void> tapFormToggleButton() async {
    final registerBtn = find.byType(CustomTextButton);
    expect(registerBtn, findsOneWidget);
    await tester.tap(registerBtn);
    await tester.pumpAndSettle();
  }

  void expectCreateAccountButtonFound() {
    final createAccountBtn = find.text('Create an account');
    expect(createAccountBtn, findsOneWidget);
  }

  void expectCreateAccountButtonNotFound() {
    final createAccountBtn = find.text('Create an account');
    expect(createAccountBtn, findsNothing);
  }
}
