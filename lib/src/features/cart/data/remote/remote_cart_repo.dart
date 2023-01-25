import 'package:ecommerce_app_miki/src/features/cart/domain/cart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class RemoteCartRepository {
  Future<Cart> fetchCart(String uid);

  Stream<Cart> watchCart(String uid);

  Future<void> setCart(String uid, Cart cart);
}

final remoteCartRepoProvider = Provider<RemoteCartRepository>((ref) {
  // override this in the main.dart file to use a different implementation
  throw UnimplementedError();
});
