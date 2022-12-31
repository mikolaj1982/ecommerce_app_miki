import 'dart:core';

import 'package:ecommerce_app_miki/src/constants/test_products.dart';
import 'package:ecommerce_app_miki/src/models/product_model.dart';
import 'package:ecommerce_app_miki/src/utils/delay.dart';

class FakeProductsRepository {
  final bool addDelay;
  final List<Product> _products = testProducts;

  FakeProductsRepository({this.addDelay = true});

  Product? getProductById(String id) {
    return _getProduct(_products, id);
  }

  // final List<Product?> _products = testProducts;
  // Product? getProductById(String id) {
  //   return _products.firstWhere((product) => product!.id == id, orElse: () => null);
  // }

  Stream<Product?> watchProduct(String id) {
    return watchProductsListWithDelay().map((products) => _getProduct(products, id));
  }

  static Product? _getProduct(List<Product> products, String id) {
    try {
      return products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Product>> fetchProductsList() async {
    await delay(addDelay);
    return Future.value(_products);
  }

  Future<List<Product>> fetchProductsListWithError() async {
    await delay(addDelay);
    throw Exception('Connection failed');
    // return Future.value(_products);
  }

  List<Product> getProductsList() {
    return _products;
  }

  Stream<List<Product>> watchProductsListWithDelay() async* {
    await delay(addDelay);
    yield _products;
  }

  Stream<List<Product>> watchProductsList() {
    return Stream.value(_products);
  }
}
