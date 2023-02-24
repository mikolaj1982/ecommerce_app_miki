import 'package:ecommerce_app_miki/src/common_widgets/primary_button.dart';
import 'package:ecommerce_app_miki/src/features/checkout/payment/payment_button_controller.dart';
import 'package:ecommerce_app_miki/src/utils/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaymentButton extends ConsumerWidget {
  const PaymentButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(paymentControllerProvider);
    ref.listen<AsyncValue>(
      paymentControllerProvider,
      (_, state) => state.showSnackBarOnError(context),
    );

    return PrimaryButton(
      isLoading: state.isLoading,
      text: 'Pay',
      onPressed: state.isLoading
          ? null
          : () {
              ref.read(paymentControllerProvider.notifier).pay();
            },
    );
  }
}
