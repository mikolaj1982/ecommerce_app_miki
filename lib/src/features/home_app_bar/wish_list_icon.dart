import 'package:ecommerce_app_miki/src/features/cart/application/wish_list_service.dart';
import 'package:ecommerce_app_miki/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class WishListIcon extends ConsumerWidget {
  const WishListIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int wishListItemsCount = ref.watch(wishListItemsCountProvider);

    return Stack(
      children: [
        Center(
          child: IconButton(
            icon: const Icon(Icons.list),
            onPressed: () => context.pushNamed(AppRoute.wishList.name),
          ),
        ),
        if (wishListItemsCount > 0)
          Positioned(
            top: 4.0,
            right: 4.0,
            child: WishListIconBadge(itemsCount: wishListItemsCount),
          ),
      ],
    );
  }
}

class WishListIconBadge extends StatelessWidget {
  final int itemsCount;

  const WishListIconBadge({
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
          color: Colors.blue,
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
