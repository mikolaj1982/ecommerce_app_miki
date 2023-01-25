import 'package:ecommerce_app_miki/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app_miki/src/features/cart/domain/item_model.dart';
import 'package:ecommerce_app_miki/src/features/products/product_page/add_to_cart_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';

void main() {
  ProviderContainer makeProviderContainer(MockCartService cartService) {
    final container = ProviderContainer(
      overrides: [
        cartServiceProvider.overrideWithValue(cartService),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('addItem', () {
    test('item added with quantity = 2, success', () async {
      // setup
      const quantity = 2;
      const productId = '1';
      const item = Item(productId: productId, quantity: quantity);
      final mockCartService = MockCartService();
      when(() => mockCartService.addItem(item)).thenAnswer(
        (_) => Future.value(null),
      );

      // run & verify
      final container = makeProviderContainer(mockCartService);
      final cartController = container.read(addToCartControllerProvider.notifier);
      final quantityController = container.read(itemQuantityControllerProvider.notifier);
      expect(
        quantityController.debugState,
        1,
      );
      await quantityController.updateQuantity(quantity);
      expect(
        quantityController.debugState,
        2,
      );

      await cartController.addItem(item.productId);
      verify(() => mockCartService.addItem(item)).called(1);

      // check that quantity goes back to 1 after adding an item
      expect(quantityController.debugState, 1);
    });
  });

  test('item added with quantity = 2, failure', () async {
    // setup
    const quantity = 42;
    const productId = '1';
    const item = Item(productId: productId, quantity: quantity);
    final mockCartService = MockCartService();
    when(() => mockCartService.addItem(item)).thenThrow(
      (_) => Exception('Error adding item'),
    );

    // run & verify
    final container = makeProviderContainer(mockCartService);
    final cartController = container.read(addToCartControllerProvider.notifier);
    final quantityController = container.read(itemQuantityControllerProvider.notifier);
    expect(
      quantityController.debugState,
      1,
    );
    await quantityController.updateQuantity(quantity);
    expect(
      quantityController.debugState,
      42,
    );

    await cartController.addItem(item.productId);
    verify(() => mockCartService.addItem(item)).called(1);

    // check that quantity goes back to 1 after adding an item
    expect(cartController.debugState, predicate<AsyncValue<void>>(
      (value) {
        expect(value.hasError, true);
        return true;
      },
    ));
  });
}
