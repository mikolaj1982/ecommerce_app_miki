import 'package:ecommerce_app_miki/src/features/authentication/domain/app_user_model.dart';
import 'package:ecommerce_app_miki/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum PopupMenuOption {
  sigIn,
  orders,
  account,
}

class MoreMenuButton extends StatelessWidget {
  final AppUser? user;

  const MoreMenuButton({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(Icons.more_vert),
      itemBuilder: (_) {
        return user != null
            ? <PopupMenuEntry<PopupMenuOption>>[
                const PopupMenuItem(
                  value: PopupMenuOption.orders,
                  child: Text('Orders'),
                ),
                const PopupMenuItem(
                  value: PopupMenuOption.account,
                  child: Text('Account'),
                ),
              ]
            : <PopupMenuEntry<PopupMenuOption>>[
                const PopupMenuItem(
                  value: PopupMenuOption.sigIn,
                  child: Text('Sign In'),
                ),
              ];
      },
      onSelected: (option) {
        switch (option) {
          case PopupMenuOption.sigIn:
            context.pushNamed(AppRoute.signIn.name);
            break;
          case PopupMenuOption.orders:
            context.pushNamed(AppRoute.orders.name);
            break;
          case PopupMenuOption.account:
            context.pushNamed(AppRoute.account.name);
            break;
          default:
            debugPrint('Unhandled option: $option');
            break;
        }
      },
    );
  }
}
