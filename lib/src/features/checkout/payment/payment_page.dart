import 'package:ecommerce_app_miki/src/constants/test_products.dart';
import 'package:ecommerce_app_miki/src/features/checkout/payment/payment_button.dart';
import 'package:ecommerce_app_miki/src/features/shopping_cart/shopping_cart_item.dart';
import 'package:ecommerce_app_miki/src/features/shopping_cart/shopping_cart_items_builder.dart';
import 'package:flutter/material.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    const cartItems = shoppingCartItems;

    return ShoppingCartItemsBuilder(
      items: cartItems,
      itemBuilder: (_, item, index) => ShoppingCartItem(
        item: item,
        itemIndex: index,
        isEditable: false,
      ),
      ctaBuilder: (_) => const PaymentButton(),
    );
  }
}
