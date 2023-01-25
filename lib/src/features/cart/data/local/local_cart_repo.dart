import 'package:ecommerce_app_miki/src/features/cart/domain/cart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class LocalCartRepository {
  Future<Cart> fetchCart();

  Future<void> setCart(Cart cart);

  Stream<Cart> watchCart();
}

final localCartRepoProvider = Provider<LocalCartRepository>((ref) {
  // override this in the main.dart file to use a different implementation
  throw UnimplementedError();
});
