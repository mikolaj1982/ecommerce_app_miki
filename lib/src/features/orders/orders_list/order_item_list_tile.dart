import 'package:ecommerce_app_miki/src/common_widgets/async_value_widget_with_shimmer.dart';
import 'package:ecommerce_app_miki/src/features/products/providers/products_provider.dart';
import 'package:ecommerce_app_miki/src/models/item_model.dart';
import 'package:ecommerce_app_miki/src/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderItemListTile extends ConsumerWidget {
  final Item item;

  const OrderItemListTile({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<Product?> productValue = ref.watch(productProvider(item.productId));
    return AsyncValueWidgetWithShimmer<Product?>(
      value: productValue,
      data: (product) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: Image.asset(
                  product!.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.title),
                    const SizedBox(width: 8),
                    Text(
                      'Quantity: ${item.quantity}',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
