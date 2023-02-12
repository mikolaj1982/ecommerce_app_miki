import 'package:ecommerce_app_miki/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app_miki/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app_miki/src/features/cart/data/remote/remote_cart_repo.dart';
import 'package:ecommerce_app_miki/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app_miki/src/features/orders/fake_orders_repository.dart';
import 'package:ecommerce_app_miki/src/models/order_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FakeCheckoutService {
  FakeCheckoutService(this.ref);

  final Ref ref;

  Future<void> placeOrder() async {
    final ordersRepo = ref.watch(fakeOrdersRepoProvider);
    final authRepo = ref.watch(authRepositoryProvider);
    final remoteCartRepo = ref.watch(remoteCartRepoProvider);

    final uid = authRepo.currentUser!.uid;
    /// 1. Fetch the cart object
    final cart = await remoteCartRepo.fetchCart(uid);
    if (cart.items.isNotEmpty) {
      final total = ref.read(cartTotalProvider);
      final currentDate = DateTime.now();
      final orderId = currentDate.toIso8601String();
      /// 2. Create an order
      final order = Order(
        id: orderId,
        userId: uid,
        items: cart.items,
        orderStatus: OrderStatus.confirmed,
        orderDate: currentDate,
        total: total,
      );
      /// 3. Save it using the repository
      await ordersRepo.addOrder(uid, order);
      /// 4. Empty rhe cart
      await remoteCartRepo.setCart(uid, const Cart());
    } else {
      throw StateError('Can\'t place an order if the cart is empty');
    }
  }
}

final checkoutServiceProvider = Provider<FakeCheckoutService>((ref) {
  return FakeCheckoutService(ref);
});
