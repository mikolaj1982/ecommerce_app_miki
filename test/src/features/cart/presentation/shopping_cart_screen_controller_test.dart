import 'package:ecommerce_app_miki/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app_miki/src/features/cart/domain/item_model.dart';
import 'package:ecommerce_app_miki/src/features/cart/presentation/shopping_cart_screen_controller.dart';
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

  setUpAll(() {
    registerFallbackValue(const AsyncLoading<int>());
  });

  group('updateItemQuantity', () {
    test('update item quantity = 40, success', () async {
      // 1. setup
      Item itemToUpdate = const Item(productId: '1', quantity: 40);
      final mockCartService = MockCartService();
      final container = makeProviderContainer(mockCartService);
      final controller = container.read(shoppingCartScreenControllerProvider.notifier);
      when(() => mockCartService.setItem(itemToUpdate)).thenAnswer(
        (_) => Future.value(),
      );

      final listener = Listener<AsyncValue<void>>();
      container.listen(
        shoppingCartScreenControllerProvider,
        listener,
        fireImmediately: true,
      );
      const data = AsyncData<void>(null);
      verify(() => listener(null, data));

      // 2. run
      await controller.updateItemQuantity(itemToUpdate.productId, 40);

      // 3. verify
      verifyInOrder([
        () => listener(data, any(that: isA<AsyncLoading>())),
        () => listener(any(that: isA<AsyncLoading>()), data),
      ]);
      verifyNoMoreInteractions(listener);
      verify(() => mockCartService.setItem(itemToUpdate)).called(1);
      expect(controller.debugState, const AsyncData<void>(null));
    });

    test('update item quantity = 40, failure', () async {
      Item itemToUpdate = const Item(productId: '1', quantity: 40);
      final mockCartService = MockCartService();
      final container = makeProviderContainer(mockCartService);
      final controller = container.read(shoppingCartScreenControllerProvider.notifier);
      when(() => mockCartService.setItem(itemToUpdate)).thenThrow(
        (_) => Exception('Error updating item'),
      );

      // 2. run
      await controller.updateItemQuantity(itemToUpdate.productId, 40);
      verify(() => mockCartService.setItem(itemToUpdate)).called(1);
      expect(controller.debugState, predicate<AsyncValue<void>>(
        (value) {
          expect(value.hasError, true);
          return true;
        },
      ));
    });
  });

  group('removeItemByID', () {
    test('remove item, success', () async {
      // 1. setup
      Item itemToRemove = const Item(productId: '1', quantity: 466);
      final mockCartService = MockCartService();
      final container = makeProviderContainer(mockCartService);
      final controller = container.read(shoppingCartScreenControllerProvider.notifier);
      when(() => mockCartService.removeItemById(itemToRemove.productId)).thenAnswer(
        (_) => Future.value(null),
      );

      final listener = Listener<AsyncValue<void>>();
      container.listen(
        shoppingCartScreenControllerProvider,
        listener,
        fireImmediately: true,
      );
      const data = AsyncData<void>(null);
      verify(() => listener(null, data));

      // 2. run
      await controller.removeItemById(itemToRemove.productId);

      // 3. verify
      verifyInOrder([
            () => listener(data, any(that: isA<AsyncLoading>())),
            () => listener(any(that: isA<AsyncLoading>()), data),
      ]);
      verifyNoMoreInteractions(listener);

      verify(() => mockCartService.removeItemById(itemToRemove.productId)).called(1);
      expect(controller.debugState, const AsyncData<void>(null));
    });

    test('remove item, failure', () async {
      Item itemToRemove = const Item(productId: '1', quantity: 466);
      final mockCartService = MockCartService();
      final container = makeProviderContainer(mockCartService);
      final controller = container.read(shoppingCartScreenControllerProvider.notifier);
      when(() => mockCartService.removeItemById(itemToRemove.productId)).thenThrow(
            (_) => Exception('Error deleting item'),
      );

      final listener = Listener<AsyncValue<void>>();
      container.listen(
        shoppingCartScreenControllerProvider,
        listener,
        fireImmediately: true,
      );
      const data = AsyncData<void>(null);
      verify(() => listener(null, data));

      // 2. run
      await controller.removeItemById(itemToRemove.productId);

      // 3. verify
      verifyInOrder([
            () => listener(data, any(that: isA<AsyncLoading>())),
            () => listener(
            any(that: isA<AsyncLoading>()), any(that: isA<AsyncError>())),
      ]);
      verifyNoMoreInteractions(listener);

      verify(() => mockCartService.removeItemById(itemToRemove.productId)).called(1);
      expect(controller.debugState, predicate<AsyncValue<void>>(
            (value) {
          expect(value.hasError, true);
          return true;
        },
      ));

    });
  });
}
