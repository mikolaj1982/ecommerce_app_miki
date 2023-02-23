import 'package:ecommerce_app_miki/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_app_miki/src/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// is empty '' by default to show empty string query essentially all products
final productsSearchQueryStateProvider = StateProvider<String>(
  (ref) => '',
);

final productsSearchResultsProvider = FutureProvider.autoDispose<List<Product>>((ref) async {
  /// read the state which is value of the Search products text field
  final searchQuery = ref.watch(productsSearchQueryStateProvider);
  debugPrint('searchQuery: $searchQuery');
  final results = ref.watch(productsListSearchProvider(searchQuery).future);
  return results;
});