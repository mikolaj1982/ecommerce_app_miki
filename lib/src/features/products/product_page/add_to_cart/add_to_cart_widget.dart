import 'package:ecommerce_app_miki/src/common_widgets/item_quantity_selector.dart';
import 'package:ecommerce_app_miki/src/common_widgets/primary_button.dart';
import 'package:ecommerce_app_miki/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app_miki/src/features/cart/application/wish_list_service.dart';
import 'package:ecommerce_app_miki/src/features/products/product_page/add_to_cart_controller.dart';
import 'package:ecommerce_app_miki/src/features/products/product_page/add_to_wish_list_controller.dart';
import 'package:ecommerce_app_miki/src/models/product_model.dart';
import 'package:ecommerce_app_miki/src/utils/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddToCartWidget extends ConsumerWidget {
  final Product product;

  const AddToCartWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(
      addToCartControllerProvider,
      (_, state) => state.showSnackBarOnError(context),
    );

    final int quantity = ref.watch(itemQuantityControllerProvider);
    final availableQuantity = ref.watch(itemAvailableQuantityProvider(product));

    final AsyncValue state = ref.watch(addToCartControllerProvider);
    // debugPrint('state: $state');

    final AsyncValue<bool> isProductOnWishList = ref.watch(isProductInWishListStreamProvider(product.id));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Quantity:'),
            ItemQuantitySelector(
              maxQuantity: availableQuantity,
              quantity: quantity,
              onChanged: state.isLoading
                  ? null
                  : (int value) {
                      ref.read(itemQuantityControllerProvider.notifier).updateQuantity(value);
                    },
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Divider(),
        const SizedBox(height: 8),
        PrimaryButton(
          onPressed: availableQuantity > 0
              ? () {
                  ref.read(addToCartControllerProvider.notifier).addItem(product.id);
                }
              : null,
          isLoading: state.isLoading,
          text: availableQuantity > 0 ? 'Add to Cart' : 'Out of Stock',
        ),
        isProductOnWishList.when(
          data: (bool isProductOnWishList) {
            if(isProductOnWishList == true){
              return PrimaryButton(
                onPressed: () {
                  ref.read(addToWishListControllerProvider.notifier).removeItemById(product.id);
                },
                isLoading: state.isLoading,
                text: 'Remove from Wish List',
              );
            } else {
              return PrimaryButton(
                onPressed: () {
                  ref.read(addToWishListControllerProvider.notifier).addItemToWishList(product.id);
                },
                isLoading: state.isLoading,
                text: 'Add to Wish List',
              );
            }
          },
          loading: () => const CircularProgressIndicator(),
          error: (Object error, StackTrace? stackTrace) => const Text('Error'),
        ),
      ],
    );
  }
}
