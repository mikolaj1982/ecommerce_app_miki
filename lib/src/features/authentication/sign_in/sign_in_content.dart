import 'package:ecommerce_app_miki/src/common_widgets/custom_text_button.dart';
import 'package:ecommerce_app_miki/src/common_widgets/primary_button.dart';
import 'package:ecommerce_app_miki/src/common_widgets/responsive_scrollable_card.dart';
import 'package:ecommerce_app_miki/src/features/authentication/sign_in/sign_in_form_type.dart';
import 'package:ecommerce_app_miki/src/features/authentication/sign_in/sign_in_screen_controller.dart';
import 'package:ecommerce_app_miki/src/features/authentication/sign_in/sign_in_state.dart';
import 'package:ecommerce_app_miki/src/features/authentication/sign_in/sign_in_validators.dart';
import 'package:ecommerce_app_miki/src/features/authentication/sign_in/string_validators.dart';
import 'package:ecommerce_app_miki/src/utils/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmailPasswordSignInContents extends ConsumerStatefulWidget {
  final VoidCallback? onSignedIn;
  final SignInFormType formType;

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
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _node.dispose();
    super.dispose();
  }

  void _updateFormType() async {
    /// toggle between register and sign in form
    final controller = ref.read(singInScreenControllerProvider(widget.formType).notifier);

    _formType = _formType == SignInFormType.signIn ? SignInFormType.register : SignInFormType.signIn;
    controller.updateFormType(_formType);

    // clear the password controllers
    _passwordController.clear();
  }

  Future<void> _submit() async {
    setState(() => _submitted = true);

    // only submit if the validation passes
    if (_formKey.currentState!.validate()) {
      final controller = ref.read(singInScreenControllerProvider(widget.formType).notifier);
      final success = await controller.submit(email, password);

      if (success) {
        widget.onSignedIn?.call();
      }
    }
  }

  _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
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
      singInScreenControllerProvider(widget.formType).select((state) => state.value),
      (_, state) => state.showSnackBarOnError(context),
    );

    final SignInState state = ref.watch(singInScreenControllerProvider((widget.formType)));
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
