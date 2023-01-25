import 'dart:math';

import 'package:ecommerce_app_miki/src/common_widgets/typedefs.dart';
import 'package:ecommerce_app_miki/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app_miki/src/features/cart/data/local/local_cart_repo.dart';
import 'package:ecommerce_app_miki/src/features/cart/data/remote/remote_cart_repo.dart';
import 'package:ecommerce_app_miki/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app_miki/src/features/cart/domain/item_model.dart';
import 'package:ecommerce_app_miki/src/features/cart/domain/mutable_cart.dart';
import 'package:ecommerce_app_miki/src/features/products/providers/products_provider.dart';
import 'package:ecommerce_app_miki/src/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartService {
  CartService(this.ref);

  final Ref ref;

  /// fetch the cart from the local or remote repository
  /// depending on the user's authentication status
  Future<Cart> _fetchCart() {
    // throw Exception('not implemented');
    final user = ref.read(authRepositoryProvider).currentUser;
    return user != null
        ? ref.read(remoteCartRepoProvider).fetchCart(user.uid)
        : ref.read(localCartRepoProvider).fetchCart();
  }

  /// set the cart to the local or remote repository
  Future<void> _setCart(Cart cart) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user != null) {
      ref.read(remoteCartRepoProvider).setCart(user.uid, cart);
    } else {
      ref.read(localCartRepoProvider).setCart(cart);
    }
  }

  Future<void> setItem(Item item) async {
    final cart = await _fetchCart();
    final newCart = cart.setItem(item);
    await _setCart(newCart);
  }

  Future<void> removeItemById(ProductID productId) async {
    final cart = await _fetchCart();
    final newCart = cart.removeItemById(productId);
    await _setCart(newCart);
  }

  Future<void> clear() async {
    await _setCart(const Cart());
  }

  Future<void> addItem(Item item) async {
    debugPrint('CartService class addItem method: $item');
    final Cart cart = await _fetchCart();
    final newCart = cart.addItem(item);
    for (item in newCart.toItemsList()) {
      debugPrint('item ${item.toString()}');
    }
    await _setCart(newCart);
  }

  Future<void> addItems(List<Item> items) async {
    final cart = await _fetchCart();
    final newCart = cart.addItems(items);
    await _setCart(newCart);
  }

  Future<void> updateItemIfExists(Item item) async {
    final cart = await _fetchCart();
    final newCart = cart.updateItemIfExists(item);
    await _setCart(newCart);
  }
}

final cartServiceProvider = Provider<CartService>((ref) {
  return CartService(ref);
});

/// providers cart as a stream so it always reflects the current state
final cartStreamProvider = StreamProvider<Cart>((ref) {
  final user = ref.watch(authStateChangesProvider).value;
  return user != null
      ? ref.watch(remoteCartRepoProvider).watchCart(user.uid)
      : ref.watch(localCartRepoProvider).watchCart();
});

final cartItemsCountProvider = Provider<int>((ref) {
  final AsyncValue<Cart> cart = ref.watch(cartStreamProvider);
  return cart.when(
    data: (cart) => cart.toItemsList().length,
    loading: () => 0,
    error: (_, __) => 0,
  );
});

final cartTotalProvider = Provider.autoDispose<double>((ref) {
  /// get current cart
  final cart = ref.watch(cartStreamProvider).value ?? const Cart();

  /// get products list
  final productsList = ref.watch(productsListStreamProvider).value ?? [];
  if (productsList.isNotEmpty && cart.items.isNotEmpty) {
    var total = 0.0;
    for (final item in cart.toItemsList()) {
      final product = productsList.firstWhere((p) => p.id == item.productId);
      total += product.price * item.quantity;
    }
    return total;
  } else {
    return 0.0;
  }
});

/// create provider that disallow for adding items multiple times if quantity is higher then availableQuantity
/// for certain product - return int for availableQuantity, takes in Product product as parameter
final itemAvailableQuantityProvider = Provider.autoDispose.family<int, Product>((ref, product) {
  final cart = ref.watch(cartStreamProvider).value;
  if (cart != null) {
    // get the current quantity for the given product in the cart
    final currentQuantity = cart.items[product.id] ?? 0;
    return max(0, product.availableQuantity - currentQuantity);
  } else {
    return product.availableQuantity;
  }
});
