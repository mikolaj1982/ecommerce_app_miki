import 'package:ecommerce_app_miki/src/common_widgets/async_value_widget.dart';
import 'package:ecommerce_app_miki/src/common_widgets/responsive_two_columns_layout.dart';
import 'package:ecommerce_app_miki/src/features/cart/domain/item_model.dart';
import 'package:ecommerce_app_miki/src/features/products/product_page/add_to_wish_list_controller.dart';
import 'package:ecommerce_app_miki/src/features/products/providers/products_provider.dart';
import 'package:ecommerce_app_miki/src/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WishListItem extends ConsumerWidget {
  final Item item;
  final int itemIndex;
  final bool isEditable;

  const WishListItem({
    super.key,
    required this.item,
    required this.itemIndex,
    this.isEditable = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<Product?> productValue = ref.watch(
      productProvider(item.productId),
    );
    return AsyncValueWidget<Product?>(
      value: productValue,
      data: (product) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: WishListItemContents(
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

class WishListItemContents extends ConsumerWidget {
  final Item item;
  final int itemIndex;
  final bool isEditable;
  final Product product;

  const WishListItemContents({
    super.key,
    required this.item,
    required this.itemIndex,
    required this.product,
    this.isEditable = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            '\$${product.price}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          if (isEditable)
            EditOrRemoveWishListItemWidget(
              itemIndex: itemIndex,
              item: item,
              product: product,
            ),
        ],
      ),
    );
  }
}

class EditOrRemoveWishListItemWidget extends ConsumerWidget {
  final int itemIndex;
  final Item item;
  final Product product;

  const EditOrRemoveWishListItemWidget({
    super.key,
    required this.itemIndex,
    required this.item,
    required this.product,
  });


  // * Keys for testing using find.byKey()
  static Key deleteKey(int index) => Key('delete-$index');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addToWishListControllerProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          key: deleteKey(itemIndex),
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: state.isLoading
              ? null
              : () {
            debugPrint('Remove item');
            ref.read(addToWishListControllerProvider.notifier).removeItemById(item.productId);
          },
        ),
        const Spacer(),
      ],
    );
  }
}
