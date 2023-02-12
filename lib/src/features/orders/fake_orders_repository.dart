import 'dart:core';

import 'package:ecommerce_app_miki/src/models/order_model.dart';
import 'package:ecommerce_app_miki/src/utils/delay.dart';
import 'package:ecommerce_app_miki/src/utils/in_memory_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FakeOrdersRepository {
  final bool addDelay;

  FakeOrdersRepository({this.addDelay = true});

  /// A map of all the orders placed by all users, where:
  /// key: uid of the user
  /// value: List of orders placed by the user
  final _orders = InMemoryStore<Map<String, List<Order>>>({});

  Stream<List<Order>> watchOrders(String uid) {
    return _orders.stream.map((orders) => orders[uid] ?? []);
  }

  Future<void> addOrder(String uid, Order order) async {
    await delay(addDelay);
    final orders = _orders.value;
    final userOrders = orders[uid] ?? [];
    userOrders.add(order);
    orders[uid] = userOrders;
    _orders.value = orders;
  }
}



final fakeOrdersRepoProvider = Provider<FakeOrdersRepository>((ref) {
  return FakeOrdersRepository();
});
