import 'package:ecommerce_app_miki/src/common_widgets/action_text_button.dart';
import 'package:ecommerce_app_miki/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app_miki/src/features/authentication/domain/app_user_model.dart';
import 'package:ecommerce_app_miki/src/features/home_app_bar/shopping_cart_icon.dart';
import 'package:ecommerce_app_miki/src/features/home_app_bar/wish_list_icon.dart';
import 'package:ecommerce_app_miki/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'more_menu_button.dart';

class HomeAppBar extends ConsumerWidget with PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppUser? user = ref.watch(authStateChangesProvider).value;
    final screenWidth = MediaQuery.of(context).size.width;
    // debugPrint('HomeAppBar: build: screenWidth: $screenWidth');
    const title = 'useFakeRepository: ${const String.fromEnvironment('useFakeRepository', defaultValue: 'false')}';

    if (screenWidth < 600) {
      return AppBar(
        title: const Text(title),
        actions: [
          const ShoppingCartIcon(),
          const WishListIcon(),
          MoreMenuButton(user: user),
        ],
      );
    } else {
      return AppBar(
        title: const Text('My Shop'),
        actions: [
          const ShoppingCartIcon(),
          if (user != null) ...[
            ActionTextButton(
              text: 'Orders',
              onPressed: () => context.pushNamed(AppRoute.orders.name),
            ),
            ActionTextButton(
              key: MoreMenuButton.accountKey,
              text: 'Account',
              onPressed: () => context.pushNamed(AppRoute.account.name),
            ),
          ] else ...[
            ActionTextButton(
              key: MoreMenuButton.signInKey,
              text: 'Sign In',
              onPressed: () => context.pushNamed(AppRoute.signIn.name),
            ),
          ],
        ],
      );
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}
