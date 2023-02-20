import 'package:ecommerce_app_miki/src/common_widgets/typedefs.dart';
import 'package:ecommerce_app_miki/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app_miki/src/models/order_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'fake_orders_repository.dart';

final userOrdersProvider = StreamProvider.autoDispose<List<Order>>(
  (ref) {
    final user = ref.read(authStateChangesProvider).value;
    if (user == null) {
      return Stream.value([]);
    }
    return ref.watch(fakeOrdersRepoProvider).watchOrders(user.uid);
  },
);

/// return a stream of all the orders for a given user for a given product id, ordered by date
final userOrdersByProductProvider = StreamProvider.autoDispose.family<List<Order>, ProductID>((ref, productId) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user == null) {
    return Stream.value([]);
  }
  return ref.watch(fakeOrdersRepoProvider).watchUserOrders(user.uid, productId: productId);
});
