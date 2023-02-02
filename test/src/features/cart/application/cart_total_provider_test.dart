import 'package:ecommerce_app_miki/src/constants/test_products.dart';
import 'package:ecommerce_app_miki/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app_miki/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app_miki/src/features/products/providers/products_provider.dart';
import 'package:ecommerce_app_miki/src/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group('cartTotalProvider', () {
    /// this shows how to test provider that depends on other providers
    ProviderContainer makeProviderContainer({
      required Stream<Cart> cartStream,
      required Stream<List<Product>> productsListStream,
    }) {
      /// need following providers:
      /// cartStreamProvider and productsListStreamProvider
      final container = ProviderContainer(
        overrides: [
          cartStreamProvider.overrideWith((ref) => cartStream),
          productsListStreamProvider.overrideWith((ref) => productsListStream),
        ],
      );
      addTearDown(container.dispose);
      return container;
    }

    test('loading cart', () async {
      final container = makeProviderContainer(
        cartStream: const Stream.empty(),
        productsListStream: Stream.value(testProducts),
      );
      // debugPrint('productsListStreamProvider: ${container.read(productsListStreamProvider)}');
      /// is allowing productsListStreamProvider to be populated with values from testProducts
      await container.read(productsListStreamProvider.future);
      // debugPrint('productsListStreamProvider: ${container.read(productsListStreamProvider)}');
      final total = container.read(cartTotalProvider);
      expect(total, 0);
    });

    test('empty cart', () async {
      final container = makeProviderContainer(
        cartStream: Stream.value(const Cart()),
        productsListStream: Stream.value(testProducts),
      );

      await container.read(cartStreamProvider.future);
      await container.read(productsListStreamProvider.future);

      // debugPrint('cart: ${container.read(cartStreamProvider)}');
      // debugPrint('products: ${container.read(productsListStreamProvider)}');

      final total = container.read(cartTotalProvider);
      expect(total, 0);
    });

    test('cart product 1 3items and products 14 3items', () async {
      final container = makeProviderContainer(

        /// 1st is price 15, 14th is price 16 = 45 + 48 = 93
        cartStream: Stream.value(const Cart({'1': 3, '14': 3})),
        productsListStream: Stream.value(testProducts),
      );

      await container.read(cartStreamProvider.future);
      await container.read(productsListStreamProvider.future);

      final total = container.read(cartTotalProvider);
      expect(total, 93);
    });

    test('one product with quantity = 5', () async {
      final container = makeProviderContainer(
        cartStream: Stream.value(const Cart({'1': 5})),
        productsListStream: Stream.value(testProducts),
      );
      await container.read(cartStreamProvider.future);
      await container.read(productsListStreamProvider.future);
      final total = container.read(cartTotalProvider);
      expect(total, 75);
    });

    test('product not found', () async {
      final container = makeProviderContainer(
        cartStream: Stream.value(const Cart({'100': 1})),
        productsListStream: Stream.value(testProducts),
      );
      await container.read(cartStreamProvider.future);
      await container.read(productsListStreamProvider.future);
      expect(() => container.read(cartTotalProvider), throwsStateError);
    });
  });
}
