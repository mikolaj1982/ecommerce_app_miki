@Timeout(Duration(milliseconds: 500))
import 'package:ecommerce_app_miki/src/features/checkout/payment/checkout_service.dart';
import 'package:ecommerce_app_miki/src/features/checkout/payment/payment_button_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';

void main() {
  ProviderContainer makeProviderContainer(MockCheckoutService checkoutService) {
    final container = ProviderContainer(
      overrides: [
        checkoutServiceProvider.overrideWithValue(checkoutService),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('successful payment', () async {
    // setup
    final mockCheckoutService = MockCheckoutService();
    when(() => mockCheckoutService.placeOrder()).thenAnswer(
      (_) => Future.value(null),
    );

    // run & verify
    final container = makeProviderContainer(mockCheckoutService);
    final paymentController = container.read(paymentControllerProvider.notifier);

    expectLater(
      paymentController.stream,
      emitsInOrder([
        const AsyncLoading<void>(),
        const AsyncData<void>(null),
      ]),
    );
    await paymentController.pay();
    verify(() => mockCheckoutService.placeOrder()).called(1);
  });

  test('failure payment', () async {
    // setup
    final mockCheckoutService = MockCheckoutService();
    when(() => mockCheckoutService.placeOrder()).thenThrow(
      Exception('Card declined'),
    );

    /// run & verify
    final container = makeProviderContainer(mockCheckoutService);
    final paymentController = container.read(paymentControllerProvider.notifier);

    expectLater(
      paymentController.stream,
      emitsInOrder([
        const AsyncLoading<void>(),
        predicate<AsyncValue<void>>(
              (value) {
            expect(value.hasError, true);
            return true;
          },
        ),
      ]),
    );
    await paymentController.pay();
    verify(() => mockCheckoutService.placeOrder()).called(1);
  });
}
