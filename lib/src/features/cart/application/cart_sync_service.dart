import 'package:ecommerce_app_miki/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app_miki/src/features/authentication/domain/app_user_model.dart';
import 'package:ecommerce_app_miki/src/features/cart/data/local/local_cart_repo.dart';
import 'package:ecommerce_app_miki/src/features/cart/data/remote/remote_cart_repo.dart';
import 'package:ecommerce_app_miki/src/features/cart/domain/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartSyncService {
  final Ref ref;

  /// class that sync the cart after the user login
  CartSyncService(this.ref) {
    _init();
  }

  void _init() {
    ref.listen<AsyncValue<AppUser?>>(authStateChangesProvider, (prevState, nextState) {
      debugPrint('prevState $prevState, nextState $nextState');

      /// prevState -> AsyncData<AppUser?>(value: null) -> nextState AsyncData<AppUser?>(value: AppUser(uid: d036a8d0-9b77-11ed-a549-4989f1f94381, email: test@test.com, password: *******)) -> sync must occur
      final previousUser = prevState?.value;
      final nextUser = nextState.value;
      if (previousUser == null && nextUser != null) {
        debugPrint('sync must occur for user ${nextUser.uid}');
        _moveItemsToRemoteCart(nextUser.uid);
      }
    });
  }

  /// moves all items from the local to the remote cart taking into account the
  /// available quantities
  Future<void> _moveItemsToRemoteCart(String uid) async {
    try {
      final localCart = await ref.read(localCartRepoProvider).fetchCart();
      if (localCart.items.isNotEmpty) {
        /// fetch the remote cart data
        final remoteCart = await ref.read(remoteCartRepoProvider).fetchCart(uid);

        /// add the local items to the remote cart on top of already existing items
        final Cart newRemoteCart = remoteCart.merge(localCart);

        /// write the updated remote cart data to the repository
        await ref.read(remoteCartRepoProvider).setCart(uid, newRemoteCart);

        /// remove all items from the local cart
        await ref.read(localCartRepoProvider).setCart(const Cart());
      }
    } catch (e) {
      debugPrint('error $e');
    }
  }
}

final cartSyncServiceProvider = Provider<CartSyncService>((ref) {
  return CartSyncService(ref);
});
