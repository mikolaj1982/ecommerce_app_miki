import 'package:ecommerce_app_miki/src/common_widgets/typedefs.dart';
import 'package:ecommerce_app_miki/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_app_miki/src/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productsRepoProvider = Provider<FakeProductsRepository>(
  (ref) => FakeProductsRepository(),
);

final productsListStreamProvider = StreamProvider.autoDispose<List<Product>>((ref) {
  debugPrint('created products stream provider');
  ref.onDispose(() => debugPrint('disposed products list provider'));
  final productRepo = ref.watch(productsRepoProvider);
  return productRepo.watchProductsListWithDelay();
});

final productsListFutureProvider = FutureProvider.autoDispose<List<Product>>((ref) async {
  debugPrint('created products future provider');
  final productRepo = ref.watch(productsRepoProvider);
  return productRepo.fetchProductsList();
});

// the family modifier allow us to add a parameter
// first we specify a type of the parameter <, ProductID>
// then we can use it (ref, ProductID productId,)
final productProvider = StreamProvider.family.autoDispose<Product?, ProductID>((
  ref,
  ProductID productId,
) {
  // debugPrint('created provider with id: $productId');
  // ref.onDispose(() => debugPrint('disposed productProvider with id: $productId'));

  // final link = ref.keepAlive();
  // Timer(const Duration(seconds: 10), () {
  //   link.close();
  // });

  final productRepo = ref.watch(productsRepoProvider);
  return productRepo.watchProduct(productId);
});
