import 'package:ecommerce_app_miki/src/common_widgets/cart_total_text.dart';
import 'package:flutter/material.dart';

class CartTotalWithCTA extends StatelessWidget {
  final WidgetBuilder ctaBuilder;
  const CartTotalWithCTA({
    super.key,
    required this.ctaBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CartTotalText(),
        const SizedBox(height: 8),
        ctaBuilder(context),
        const SizedBox(height: 8),
      ],
    );
  }
}
