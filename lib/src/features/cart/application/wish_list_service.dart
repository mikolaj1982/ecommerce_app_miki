import 'package:ecommerce_app_miki/src/common_widgets/typedefs.dart';
import 'package:ecommerce_app_miki/src/features/cart/data/sembast_wish_list.dart';
import 'package:ecommerce_app_miki/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app_miki/src/features/cart/domain/item_model.dart';
import 'package:ecommerce_app_miki/src/features/cart/domain/mutable_cart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'cart_service.dart';

class WishListService {
  WishListService(this.ref);

  final Ref ref;

  Future<Cart> _fetchCart() async {
    return ref.read(sembastWishListRepoProvider).fetchCart();
  }

  Future<void> _setCart(Cart cart) async {
    ref.read(sembastWishListRepoProvider).setCart(cart);
  }

  Future<void> removeItemById(ProductID productId) async {
    final cart = await _fetchCart();
    final newCart = cart.removeItemById(productId);
    await _setCart(newCart);
  }

  Future<void> addItem(Item item) async {
    final Cart cart = await _fetchCart();
    final newCart = cart.addItem(item);
    await _setCart(newCart);
  }

  Future<void> clear() async {
    await _setCart(const Cart());
  }

  Future<void> addItemsToCartFromWishList() async {
    final cart = await _fetchCart();
    final cartService = ref.read(cartServiceProvider);
    final cartItems = cart.toItemsList();
    final cartItemsToAdd = cartItems.map((item) => item.copyWith(quantity: 1)).toList();
    await cartService.addItems(cartItemsToAdd);
    await clear();
  }
}

final isProductInWishListStreamProvider = StreamProvider.autoDispose.family<bool, ProductID>((ref, productId) {
  final Stream<Cart> cartStream = ref.watch(sembastWishListRepoProvider).watchCart();
  return cartStream.map((cart) => cart.containsItemWithId(productId));
});

final wishListStreamProvider = StreamProvider<Cart>((ref) {
  return ref.watch(sembastWishListRepoProvider).watchCart();
});

final wishListItemsCountProvider = Provider<int>((ref) {
  final AsyncValue<Cart> cart = ref.watch(wishListStreamProvider);
  return cart.when(
    data: (cart) => cart.toItemsList().length,
    loading: () => 0,
    error: (_, __) => 0,
  );
});

final sembastWishListRepoProvider = Provider<SembastWishListRepo>((ref) {
  // override this in the main.dart file to use a different implementation
  throw UnimplementedError();
});

final wishListServiceProvider = Provider<WishListService>((ref) {
  return WishListService(ref);
});
