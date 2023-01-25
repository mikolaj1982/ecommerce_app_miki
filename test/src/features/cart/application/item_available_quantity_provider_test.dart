import 'package:ecommerce_app_miki/src/constants/test_products.dart';
import 'package:ecommerce_app_miki/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app_miki/src/features/cart/domain/cart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // here we add all dependant providers we need for out test
  ProviderContainer makeProviderContainer({
    required Stream<Cart> cart,
  }) {
    final container = ProviderContainer(
      overrides: [
        cartStreamProvider.overrideWith((ref) => cart),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('itemAvailableQuantityProvider', () {
    test('loading cart', () async {
      final container = makeProviderContainer(
        cart: const Stream.empty(),
      );
      final product = testProducts[0];
      final availableQuantity = container.read(itemAvailableQuantityProvider(product));
      expect(availableQuantity, 5);
    });

    test('empty cart', () async {
      final container = makeProviderContainer(
        cart: Stream.value(const Cart()),
      );
      await container.read(cartStreamProvider.future);
      final product = testProducts[0];
      final availableQuantity = container.read(itemAvailableQuantityProvider(product));
      expect(availableQuantity, 5);
    });

    test('product with quantity = 1', () async {
      final container = makeProviderContainer(
        cart: Stream.value(
          const Cart({'1': 1}),
        ),
      );
      await container.read(cartStreamProvider.future);
      final product = testProducts[0];
      final availableQuantity = container.read(itemAvailableQuantityProvider(product));
      expect(availableQuantity, 4);
    });

    test('product with quantity = 5', () async {
      final container = makeProviderContainer(
        cart: Stream.value(
          const Cart({'1': 5}),
        ),
      );
      await container.read(cartStreamProvider.future);
      final product = testProducts[0];
      final availableQuantity = container.read(itemAvailableQuantityProvider(product));
      expect(availableQuantity, 0);
    });

    test('product with quantity = 10', () async {
      final container = makeProviderContainer(
        cart: Stream.value(
          const Cart({'1': 10}),
        ),
      );
      await container.read(cartStreamProvider.future);
      final product = testProducts[0];
      final availableQuantity = container.read(itemAvailableQuantityProvider(product));
      expect(availableQuantity, 0);
    });
  });
}
