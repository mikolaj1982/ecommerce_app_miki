import 'package:ecommerce_app_miki/src/common_widgets/async_value_widget.dart';
import 'package:ecommerce_app_miki/src/common_widgets/item_quantity_selector.dart';
import 'package:ecommerce_app_miki/src/common_widgets/responsive_two_columns_layout.dart';
import 'package:ecommerce_app_miki/src/features/products/providers/products_provider.dart';
import 'package:ecommerce_app_miki/src/models/item_model.dart';
import 'package:ecommerce_app_miki/src/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShoppingCartItem extends ConsumerWidget {
  final Item item;
  final int itemIndex;
  final bool isEditable;

  const ShoppingCartItem({
    super.key,
    required this.item,
    required this.itemIndex,
    this.isEditable = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<Product?> productValue = ref.watch(productProvider(item.productId));
    return AsyncValueWidget<Product?>(
      value: productValue,
      data: (product) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ShoppingCartItemContents(
                product: product!,
                item: item,
                itemIndex: itemIndex,
                isEditable: isEditable,
              ),
            ),
          ),
        );
      },
    );
  }
}

class ShoppingCartItemContents extends StatelessWidget {
  final Item item;
  final int itemIndex;
  final bool isEditable;
  final Product product;

  const ShoppingCartItemContents({
    super.key,
    required this.item,
    required this.itemIndex,
    required this.product,
    this.isEditable = true,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveTwoColumnLayout(
      startFlex: 1,
      endFlex: 2,
      breakpoint: 320,
      startWidget: Image.asset(product.imageUrl),
      spacing: 24.0,
      endWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.title,
            style: Theme.of(context).textTheme.headline6,
          ),
          const SizedBox(height: 8),
          Text(
            '\$${product.price}',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          const SizedBox(height: 8),
          if (isEditable)
            Row(
              children: [
                Text(
                  'Quantity: ',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                const ItemQuantitySelector(),
              ],
            )
        ],
      ),
    );
  }
}
