import 'package:ecommerce_app_miki/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app_miki/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CartTotalText extends ConsumerWidget {
  const CartTotalText({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartTotal = ref.watch(cartTotalProvider);
    final totalFormatted = ref.watch(currencyFormatterProvider).format(cartTotal);
    if (GoRouterState.of(context).name == 'wishList') {
      return Container();
    } else {
      return Text(
        'Total: $totalFormatted',
        style: Theme.of(context).textTheme.headlineSmall,
        textAlign: TextAlign.center,
      );
    }
  }
}
