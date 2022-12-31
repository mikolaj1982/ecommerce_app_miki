import 'package:ecommerce_app_miki/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ShoppingCartIcon extends StatelessWidget {
  const ShoppingCartIcon({super.key});

  @override
  Widget build(BuildContext context) {
    const cartItemsCount = 3;
    return Stack(
      children: [
        Center(
          child: IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => context.pushNamed(AppRoute.cart.name),
          ),
        ),
        if (cartItemsCount > 0)
          const Positioned(
            top: 4.0,
            right: 4.0,
            child: ShoppingCartIconBadge(itemsCount: cartItemsCount),
          ),
      ],
    );
  }
}

class ShoppingCartIconBadge extends StatelessWidget {
  final int itemsCount;

  const ShoppingCartIconBadge({
    super.key,
    required this.itemsCount,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 16.0,
      height: 16.0,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        child: Text(
          '$itemsCount',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10.0,
          ),
        ),
      ),
    );
  }
}
