import 'package:ecommerce_app_miki/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app_miki/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ShoppingCartIcon extends ConsumerWidget {
  const ShoppingCartIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int cartItemsCount = ref.watch(cartItemsCountProvider);

    // final cartValue = ref.watch(cartStreamProvider);
    // final itemsCount = cartValue.maybeWhen(
    //   data: (cart) => cart.items.length,
    //   orElse: () => 0,
    // );

    return Stack(
      children: [
        Center(
          child: IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => context.pushNamed(AppRoute.cart.name),
          ),
        ),
        if (cartItemsCount > 0)
          Positioned(
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
