import 'package:ecommerce_app_miki/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app_miki/src/utils/delay.dart';
import 'package:ecommerce_app_miki/src/utils/in_memory_store.dart';
import 'package:flutter/material.dart';

import 'local_cart_repo.dart';

class FakeLocalCartRepository implements LocalCartRepository {
  final bool addDelay;

  FakeLocalCartRepository({this.addDelay = true});

  final _cart = InMemoryStore<Cart>(const Cart());

  @override
  Future<Cart> fetchCart() {
    debugPrint('fetching cart from local repo');
    return Future.value(_cart.value);
  }

  @override
  Future<void> setCart(Cart cart) async {
    await delay(addDelay);
    _cart.value = cart;
  }

  @override
  Stream<Cart> watchCart() {
    return _cart.stream;
  }
}
