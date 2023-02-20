import 'package:ecommerce_app_miki/src/common_widgets/typedefs.dart';
import 'package:ecommerce_app_miki/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app_miki/src/features/cart/domain/item_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddToCartController extends StateNotifier<AsyncValue<void>> {
  final CartService cartService;
  final Ref ref;

  AddToCartController({
    required this.ref,
    required this.cartService,
  }) : super(const AsyncData<void>(null));

  Future<void> addItem(ProductID productId) async {
    final int quantity = ref.read(itemQuantityControllerProvider);
    final item = Item(productId: productId, quantity: quantity);
    state = const AsyncLoading();

    state = await AsyncValue.guard(() => cartService.addItem(item));
    // state = AsyncValue.error('Connection error', StackTrace.current);
    if (!state.hasError) {
      ref.read(itemQuantityControllerProvider.notifier).updateQuantity(1);
    }
  }
}

class ItemQuantityController extends StateNotifier<int> {
  ItemQuantityController() : super(1);

  Future<void> updateQuantity(int quantity) async {
    state = quantity;
  }
}

final itemQuantityControllerProvider = StateNotifierProvider.autoDispose<ItemQuantityController, int>(
  (ref) => ItemQuantityController(),
);

final addToCartControllerProvider = StateNotifierProvider.autoDispose<AddToCartController, AsyncValue<void>>((ref) {
  final cartService = ref.watch(cartServiceProvider);
  return AddToCartController(cartService: cartService, ref: ref);
});
