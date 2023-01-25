import 'package:ecommerce_app_miki/src/common_widgets/error_message_widget.dart';
import 'package:ecommerce_app_miki/src/common_widgets/primary_button.dart';
import 'package:ecommerce_app_miki/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app_miki/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app_miki/src/features/cart/presentation/shopping_cart_item.dart';
import 'package:ecommerce_app_miki/src/features/cart/presentation/shopping_cart_items_builder.dart';
import 'package:ecommerce_app_miki/src/features/cart/presentation/shopping_cart_screen_controller.dart';
import 'package:ecommerce_app_miki/src/routing/app_router.dart';
import 'package:ecommerce_app_miki/src/utils/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ShoppingCartScreen extends ConsumerWidget {
  const ShoppingCartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<void>>(
      shoppingCartScreenControllerProvider,
      (_, state) => state.showSnackBarOnError(context),
    );
    final state = ref.watch(shoppingCartScreenControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              ref.read(cartServiceProvider).clear();
            },
          ),
        ],
      ),
      body: Consumer(
        builder: (context, ref, _) {
          /// we need to read the shopping cart as a stream so it updates when the cart changes
          final AsyncValue<Cart> cart = ref.watch(cartStreamProvider);
          return cart.when(
            data: (cart) {
              return ShoppingCartItemsBuilder(
                items: cart.toItemsList(),
                itemBuilder: (_, item, index) => ShoppingCartItem(
                  item: item,
                  itemIndex: index,
                ),
                ctaBuilder: (_) => PrimaryButton(
                  isLoading: state.isLoading,
                  text: 'Checkout',
                  onPressed: () => context.pushNamed(AppRoute.checkout.name),
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
