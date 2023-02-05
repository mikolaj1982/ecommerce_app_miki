import 'package:ecommerce_app_miki/src/common_widgets/typedefs.dart';
import 'package:ecommerce_app_miki/src/features/cart/application/wish_list_service.dart';
import 'package:ecommerce_app_miki/src/features/cart/domain/item_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddToWishListController extends StateNotifier<AsyncValue<void>> {
  final WishListService wishListService;
  final Ref ref;

  AddToWishListController({
    required this.ref,
    required this.wishListService,
  }) : super(const AsyncData<void>(null));

  Future<void> addItemToWishList(ProductID productId) async {
    state = const AsyncLoading();
    final item = Item(productId: productId, quantity: 0);
    state = await AsyncValue.guard(() => wishListService.addItem(item));
  }

  Future<void> removeItemById(ProductID productId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => wishListService.removeItemById(productId));
  }

  Future<void> addItemsToCartFromWishList() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => wishListService.addItemsToCartFromWishList());
  }
}

final addToWishListControllerProvider =
    StateNotifierProvider.autoDispose<AddToWishListController, AsyncValue<void>>((ref) {
  final wishListService = ref.watch(wishListServiceProvider);
  return AddToWishListController(wishListService: wishListService, ref: ref);
});
