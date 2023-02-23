import 'dart:async';
import 'dart:core';

import 'package:ecommerce_app_miki/src/constants/test_products.dart';
import 'package:ecommerce_app_miki/src/features/products/providers/products_provider.dart';
import 'package:ecommerce_app_miki/src/models/product_model.dart';
import 'package:ecommerce_app_miki/src/utils/delay.dart';
import 'package:ecommerce_app_miki/src/common_widgets/typedefs.dart';
import 'package:ecommerce_app_miki/src/utils/in_memory_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FakeProductsRepository {
  final bool addDelay;

  // final List<Product> _products = testProducts;
  final _products = InMemoryStore<List<Product>>(List.from(testProducts));

  FakeProductsRepository({this.addDelay = true});

  Product? getProductById(String id) {
    return _getProduct(_products.value, id);
  }

  // final List<Product?> _products = testProducts;
  // Product? getProductById(String id) {
  //   return _products.firstWhere((product) => product!.id == id, orElse: () => null);
  // }

  /// update the product (like product rating) or add a new one
  Future<void> setProduct(Product product) async {
    await delay(addDelay);
    final index = _products.value.indexWhere((p) => p.id == product.id);
    if (index == -1) {
      _products.value.add(product);
    } else {
      _products.value[index] = product;
    }
  }

  /// get a product by id
  Future<Product?> getProductByID(ProductID productId) async {
    await delay(addDelay);
    final index = _products.value.indexWhere((p) => p.id == productId);
    if (index == -1) {
      return null;
    } else {
      return _products.value[index];
    }
  }

  Stream<Product?> watchProduct(String id) {
    return watchProductsListWithDelay().map((products) => _getProduct(products, id));
  }

  Future<List<Product>> searchProducts(String query) async {
    assert(
      _products.value.length <= 100,
      'Client-side search should only be performed if the number of products is small. '
      'Consider doing server-side search for larger datasets.',
    );
    final queryProducts = _products.value
        .where(
          (product) => product.title.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
    return queryProducts;
  }

  static Product? _getProduct(List<Product> products, String id) {
    try {
      return products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Product>> fetchProductsList() async {
    // await delay(addDelay);
    return Future.value(_products.value);
  }

  Future<List<Product>> fetchProductsListWithError() async {
    await delay(addDelay);
    throw Exception('Connection failed');
    // return Future.value(_products);
  }

  List<Product> getProductsList() {
    return _products.value;
  }

  Stream<List<Product>> watchProductsListWithDelay() async* {
    await delay(addDelay);
    yield _products.value;
  }

  Stream<List<Product>> watchProductsList() {
    return Stream.value(_products.value);
  }
}

final productsListSearchProvider = FutureProvider.autoDispose.family<List<Product>, String>((ref, query) async {
  /// implementing a caching strategy,  by calling keep alive we are telling the provider to not be disposed when all listeners have been removed, in practise it means if we change the query all results will be kept in memory for 5 seconds
  ref.onDispose(() {
    debugPrint('disposing search provider for $query');
  });

  ref.onCancel(() {
    debugPrint('cancel $query');
  });
  final link = ref.keepAlive();
  Timer(const Duration(seconds: 5), () {
    /// if the provider is not used for 5 seconds, it will be disposed
    link.close();
  });

  /// debouncing is a technique to prevent to many network requests when we search as we type
  /// idea behind it is that we only make a network request once we stop typing for a certain amount of time
  await Future.delayed(const Duration(milliseconds: 500));

  final productsRepository = ref.watch(productsRepoProvider);
  final List<Product> result = await productsRepository.searchProducts(query);
  debugPrint('searching for $query from provider, found ${result.length} products');
  return result;
});
