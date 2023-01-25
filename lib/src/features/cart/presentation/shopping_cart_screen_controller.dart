import 'package:ecommerce_app_miki/src/common_widgets/typedefs.dart';
import 'package:ecommerce_app_miki/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app_miki/src/features/cart/domain/item_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShoppingCartScreenController extends StateNotifier<AsyncValue<void>> {
  final CartService cartService;

  ShoppingCartScreenController({
    required this.cartService,
  }) : super(const AsyncData(null));

  Future<void> updateItemQuantity(ProductID productId, int quantity) async {
    final updatedItem = Item(productId: productId, quantity: quantity);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => cartService.setItem(updatedItem));
  }

  Future<void> removeItemById(ProductID productId) async {
    state = const AsyncLoading();
    /// closures are used to create the anonymous functions, they are used in situations where you need to pass a function as an argument to another function, or when you want to create a function that can be called later on.
    state = await AsyncValue.guard(() => cartService.removeItemById(productId));
  }
}

final shoppingCartScreenControllerProvider =
    StateNotifierProvider.autoDispose<ShoppingCartScreenController, AsyncValue<void>>((ref) {
  final cartService = ref.watch(cartServiceProvider);
  return ShoppingCartScreenController(cartService: cartService);
});
