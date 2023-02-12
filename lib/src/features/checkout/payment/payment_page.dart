import 'package:ecommerce_app_miki/src/common_widgets/async_value_widget.dart';
import 'package:ecommerce_app_miki/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app_miki/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app_miki/src/features/cart/presentation/shopping_cart_item.dart';
import 'package:ecommerce_app_miki/src/features/cart/presentation/shopping_cart_items_builder.dart';
import 'package:ecommerce_app_miki/src/features/checkout/payment/payment_button.dart';
import 'package:ecommerce_app_miki/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PaymentPage extends ConsumerWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<Cart>>(cartStreamProvider, (_, state) {
      state.when(
        data: (cart) {
          if (cart.toItemsList().isEmpty) {
            /// go to orders page every time this listener discover that cart is empty
            context.goNamed(AppRoute.orders.name);
          }
        },
        loading: () {},
        error: (_, __) {},
      );
    });

    // ref.listen<double>(cartTotalProvider, (_, cartTotal) {
    //   /// If the cart total becomes 0, it means that the order has been fulfilled
    //   /// because all the items have been removed from the cart.
    //   /// So we should go to the orders page.
    //   if(cartTotal == 0) {
    //     context.goNamed(AppRoute.orders.name);
    //   }
    // });

    final AsyncValue<Cart> cartValue = ref.watch(cartStreamProvider);
    return AsyncValueWidget<Cart>(
        value: cartValue,
        data: (cart) {
          return ShoppingCartItemsBuilder(
            items: cart.toItemsList(),
            itemBuilder: (_, item, index) => ShoppingCartItem(
              item: item,
              itemIndex: index,
              isEditable: false,
            ),
            ctaBuilder: (_) => const PaymentButton(),
          );
        });
  }
}
