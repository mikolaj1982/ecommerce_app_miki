import 'package:ecommerce_app_miki/src/common_widgets/primary_button.dart';
import 'package:ecommerce_app_miki/src/constants/test_products.dart';
import 'package:ecommerce_app_miki/src/features/shopping_cart/shopping_cart_item.dart';
import 'package:ecommerce_app_miki/src/features/shopping_cart/shopping_cart_items_builder.dart';
import 'package:ecommerce_app_miki/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ShoppingCartScreen extends StatelessWidget {
  const ShoppingCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const cartItems = shoppingCartItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
      ),
      body: ShoppingCartItemsBuilder(
        items: cartItems,
        itemBuilder: (_, item, index) => ShoppingCartItem(
          item: item,
          itemIndex: index,
        ),
        ctaBuilder: (_) => PrimaryButton(
          text: 'Checkout',
          onPressed: () => context.pushNamed(AppRoute.checkout.name),
        ),
      ),
    );
  }
}
