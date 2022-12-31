import 'package:ecommerce_app_miki/src/common_widgets/item_quantity_selector.dart';
import 'package:ecommerce_app_miki/src/common_widgets/primary_button.dart';
import 'package:ecommerce_app_miki/src/models/product_model.dart';
import 'package:flutter/material.dart';

class AddToCartWidget extends StatelessWidget {
  final Product product;

  const AddToCartWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    const availableQuantity = 10;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Quantity:'),
            ItemQuantitySelector(),
          ],
        ),
        const SizedBox(height: 8),
        const Divider(),
        const SizedBox(height: 8),
        PrimaryButton(
          onPressed: () {
            debugPrint('Added to cart');
          },
          isLoading: false,
          text: availableQuantity > 0 ? 'Add to Cart' : 'Out of Stock',
        ),
      ],
    );
  }
}
