import 'package:ecommerce_app_miki/src/common_widgets/primary_button.dart';
import 'package:flutter/material.dart';

class PaymentButton extends StatelessWidget {
  const PaymentButton({super.key});

  Future<void> _pay(BuildContext context) async {
    //TODO: Implement
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      isLoading: false,
      text: 'Pay',
      onPressed: () => _pay(context),
    );
  }
}
