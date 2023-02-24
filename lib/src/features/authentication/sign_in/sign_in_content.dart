import 'package:ecommerce_app_miki/src/common_widgets/custom_text_button.dart';
import 'package:ecommerce_app_miki/src/common_widgets/primary_button.dart';
import 'package:ecommerce_app_miki/src/common_widgets/responsive_scrollable_card.dart';
import 'package:ecommerce_app_miki/src/features/authentication/sign_in/sign_in_form_type.dart';
import 'package:ecommerce_app_miki/src/features/authentication/sign_in/sign_in_screen_controller.dart';
import 'package:ecommerce_app_miki/src/features/authentication/sign_in/sign_in_validators.dart';
import 'package:ecommerce_app_miki/src/features/authentication/sign_in/string_validators.dart';
import 'package:ecommerce_app_miki/src/utils/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmailPasswordSignInContents extends ConsumerStatefulWidget {
  final VoidCallback? onSignedIn;
  final SignInFormType formType;

  // * Keys for testing using find.byKey()
  static const emailKey = Key('email');
  static const passwordKey = Key('password');

  const EmailPasswordSignInContents({
    super.key,
    required this.formType,
    this.onSignedIn,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EmailPasswordSignInContentsState();
}

class _EmailPasswordSignInContentsState extends ConsumerState<EmailPasswordSignInContents>
    with EmailAndPasswordValidators {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _node = FocusScopeNode();
  final _formKey = GlobalKey<FormState>();

  String get email => _emailController.text;

  String get password => _passwordController.text;

  var _submitted = false;

  late SignInFormType _formType = widget.formType;

  @override
  void initState() {
    /// only for testing purposes
    // setState(() {
    //   Future.delayed(Duration.zero, () {
    //     _updateFormType();
    //     _emailController.text = 'test@test.com';
    //     _passwordController.text = 'kupa123';
    //   });
    // });

    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _node.dispose();
    super.dispose();
  }

  void _updateFormType() async {
    /// toggle between register and sign in form
    setState(() => _formType = _formType.secondaryActionFormType);

    // clear the password controllers
    _passwordController.clear();
  }

  Future<void> _submit() async {
    setState(() => _submitted = true);

    // only submit if the validation passes
    if (_formKey.currentState!.validate()) {
      final controller = ref.read(signInControllerProvider.notifier);
      final success = await controller.submit(email: email, password: password, formType: _formType);

      if (success) {
        widget.onSignedIn?.call();
      }
    }
  }

  _emailEditingComplete() {
    if (canSubmitEmail(email)) {
      _node.nextFocus();
    }
  }

  _passwordEditingComplete() {
    if (!canSubmitEmail(email)) {
      _node.previousFocus();
      return;
    }
    _submit();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      signInControllerProvider,
      (_, state) => state.showSnackBarOnError(context),
    );
    final AsyncValue<void> state = ref.watch(signInControllerProvider);
    return ResponsiveScrollableCard(
      child: FocusScope(
        node: _node,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                  controller: _emailController,
                  key: EmailPasswordSignInContents.emailKey,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'test@test.com',
                    enabled: !state.isLoading,
                  ),
                  autocorrect: false,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardAppearance: Brightness.light,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => _emailEditingComplete(),
                  inputFormatters: [
                    ValidatorInputFormatter(
                      /// which characters are allowed to be typed
                      editingValidator: EmailEditingRegexValidator(),
                    ),
                  ],

                  /// validation of the email address from EmailAndPasswordValidators mixin
                  validator: (email) => !_submitted ? null : emailErrorText(email ?? '')),
              const SizedBox(height: 8),
              TextFormField(
                controller: _passwordController,
                key: EmailPasswordSignInContents.passwordKey,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'kupa123',
                  enabled: !state.isLoading,
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                obscureText: true,
                autocorrect: false,
                keyboardAppearance: Brightness.light,
                textInputAction: TextInputAction.done,
                onEditingComplete: () => _passwordEditingComplete(),
                validator: (password) => !_submitted ? null : passwordErrorText(password ?? '', _formType),
              ),
              const SizedBox(height: 8),
              PrimaryButton(
                text: _formType.primaryButtonText,
                isLoading: state.isLoading,
                onPressed: state.isLoading ? null : () => _submit(),
              ),
              const SizedBox(height: 8),
              CustomTextButton(
                text: _formType.secondaryButtonText,
                onPressed: state.isLoading ? null : _updateFormType,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
