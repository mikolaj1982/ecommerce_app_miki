import 'package:ecommerce_app_miki/src/features/cart/data/remote/remote_cart_repo.dart';
import 'package:ecommerce_app_miki/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app_miki/src/utils/delay.dart';
import 'package:ecommerce_app_miki/src/utils/in_memory_store.dart';
import 'package:flutter/material.dart';

class FakeRemoteCartRepository implements RemoteCartRepository {
  final bool addDelay;

  /// an InMemoryStore containing the shopping cart data for all users, where:
  /// key: uid of the user
  /// value: Cart of the user
  final _carts = InMemoryStore<Map<String, Cart>>({});

  FakeRemoteCartRepository({this.addDelay = true});

  @override
  Future<Cart> fetchCart(String uid) async {
    await delay(addDelay);
    debugPrint('fetching cart from remote repo ($uid)');
    return Future.value(_carts.value[uid] ?? const Cart());
  }

  @override
  Future<void> setCart(String uid, Cart cart) async {
    await delay(addDelay);

    /// get the current carts data for all users
    final carts = _carts.value;

    /// set the cart for the given uid
    carts[uid] = cart;

    /// finally update the carts data (will emit the new value)
    _carts.value = carts;
  }

  @override
  Stream<Cart> watchCart(String uid) {
    return _carts.stream.map((carts) => carts[uid] ?? const Cart());
  }
}
