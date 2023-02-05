import 'package:ecommerce_app_miki/src/common_widgets/error_message_widget.dart';
import 'package:ecommerce_app_miki/src/common_widgets/primary_button.dart';
import 'package:ecommerce_app_miki/src/features/cart/application/wish_list_service.dart';
import 'package:ecommerce_app_miki/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app_miki/src/features/cart/presentation/shopping_cart_items_builder.dart';
import 'package:ecommerce_app_miki/src/features/cart/presentation/wish_list_item.cart.dart';
import 'package:ecommerce_app_miki/src/features/products/product_page/add_to_wish_list_controller.dart';
import 'package:ecommerce_app_miki/src/routing/app_router.dart';
import 'package:ecommerce_app_miki/src/utils/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class WishListScreen extends ConsumerWidget {
  const WishListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<void>>(
      addToWishListControllerProvider,
      (_, state) => state.showSnackBarOnError(context),
    );
    final state = ref.watch(addToWishListControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wish List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              ref.read(wishListServiceProvider).clear();
            },
          ),
        ],
      ),
      body: Consumer(
        builder: (context, ref, _) {
          final AsyncValue<Cart> cart = ref.watch(wishListStreamProvider);
          return cart.when(
            data: (cart) {
              return ShoppingCartItemsBuilder(
                items: cart.toItemsList(),
                itemBuilder: (_, item, index) => WishListItem(
                  item: item,
                  itemIndex: index,
                ),
                ctaBuilder: (_) => PrimaryButton(
                  isLoading: state.isLoading,
                  text: 'Add From Wish List To Cart',
                  onPressed: () {
                    context.pushNamed(AppRoute.cart.name);
                    ref.read(addToWishListControllerProvider.notifier).addItemsToCartFromWishList();
                  },
                ),
              );
            },
            error: (error, _) => Center(child: ErrorMessageWidget(error.toString())),
            loading: () => const Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
