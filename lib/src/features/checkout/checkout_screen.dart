import 'package:ecommerce_app_miki/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app_miki/src/features/authentication/sign_in/sign_in_content.dart';
import 'package:ecommerce_app_miki/src/features/authentication/sign_in/sign_in_form_type.dart';
import 'package:ecommerce_app_miki/src/features/checkout/payment/payment_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The two sub-routes that are present in the checkout flow.
enum CheckoutSubRoute {
  register,
  payment,
}

/// This is the root widget of the checkout flow, which is composed of 2 pages:
/// 1. Register Page
/// 2. Payment Page
/// is showing the correct page based on the user's authentication state.
class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  late final PageController _controller;
  var _subRoute = CheckoutSubRoute.register;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user != null) {
      setState(() => _subRoute = CheckoutSubRoute.payment);
    }
    _controller = PageController(initialPage: _subRoute.index);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _onSignedIn() {
    setState(() => _subRoute = CheckoutSubRoute.payment);
    _controller.animateToPage(
      _subRoute.index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = _subRoute == CheckoutSubRoute.register ? 'Register' : 'Payment';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),// to prevent swiping between pages
        // physics: const BouncingScrollPhysics(), // allow for swiping for test
        controller: _controller,
        children: [
          EmailPasswordSignInContents(
            formType: SignInFormType.register,
            onSignedIn: _onSignedIn,
          ),
          const PaymentPage(),
        ],
      ),
    );
  }
}
