import 'dart:core';

import 'package:ecommerce_app_miki/src/common_widgets/typedefs.dart';
import 'package:ecommerce_app_miki/src/features/authentication/data/fake_auth_repository.dart';
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

  /// a stream that returns all the orders for a given user, ordered by date
  /// only user orders that match the given productId will be returned.
  /// If a productId is not passed, all user orders will be returned.
  Stream<List<Order>> watchUserOrders(String uid, {ProductID? productId}) {
    return _orders.stream.map((orders) {
      final userOrders = orders[uid] ?? [];
      /// sort by date
      userOrders.sort((a, b) => b.orderDate.compareTo(a.orderDate));
      if (productId != null) {
        return userOrders.where((order) => order.items.keys.contains(productId)).toList();
      }
      return userOrders;
    });
  }
}

final fakeOrdersRepoProvider = Provider<FakeOrdersRepository>((ref) {
  return FakeOrdersRepository();
});
