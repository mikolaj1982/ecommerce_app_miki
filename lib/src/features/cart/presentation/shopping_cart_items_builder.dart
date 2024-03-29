import 'package:ecommerce_app_miki/src/common_widgets/cart_total_with_cta.dart';
import 'package:ecommerce_app_miki/src/common_widgets/decorated_box_with_shadow.dart';
import 'package:ecommerce_app_miki/src/common_widgets/responsive_center.dart';
import 'package:ecommerce_app_miki/src/features/cart/domain/item_model.dart';
import 'package:ecommerce_app_miki/src/features/not_found/empty_placeholder_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ShoppingCartItemsBuilder extends StatelessWidget {
  final List<Item> items;
  final Widget Function(BuildContext context, Item item, int) itemBuilder;
  final WidgetBuilder ctaBuilder;

  const ShoppingCartItemsBuilder({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.ctaBuilder,
  });

  @override
  Widget build(BuildContext context) {
    /// if there are no items, show a placeholder
    if (items.isEmpty) {
      if (GoRouterState.of(context).name == 'wishList') {
        return const EmptyPlaceholderWidget(
          message: 'Your wish list is empty',
        );
      } else {
        return const EmptyPlaceholderWidget(
          message: 'Your cart is empty',
        );
      }
    }

    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= 600) {
      return ResponsiveCenter(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Flexible(
                flex: 3,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return itemBuilder(context, item, index);
                  },
                  itemCount: items.length,
                ),
              ),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: CartTotalWithCTA(ctaBuilder: ctaBuilder),
                ),
              )
            ],
          ));
    } else {
      return Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return itemBuilder(context, item, index);
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: DecoratedBoxWithShadow(
                  child: CartTotalWithCTA(ctaBuilder: ctaBuilder),
                ),
              ),
            ],
          ),
        ],
      );
    }
  }
}
