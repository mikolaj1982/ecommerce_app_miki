import 'package:ecommerce_app_miki/src/features/authentication/sign_in/sign_in_content.dart';
import 'package:ecommerce_app_miki/src/features/authentication/sign_in/sign_in_form_type.dart';
import 'package:flutter/material.dart';

class EmailPasswordSignInScreen extends StatelessWidget {
  final SignInFormType formType;

  const EmailPasswordSignInScreen({
    super.key,
    required this.formType,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: EmailPasswordSignInContents(formType: formType),
      backgroundColor: Colors.grey[200],
    );
  }
}
