import 'package:ecommerce_app_miki/src/features/checkout/payment/checkout_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaymentController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  PaymentController({
    required this.ref,
  }) : super(const AsyncData<void>(null));

  Future<void> pay() async {
    state = const AsyncLoading();
    final checkoutService = ref.watch(checkoutServiceProvider);

    /// those two lines are equivalent
    /// state = await AsyncValue.guard(checkoutService.placeOrder);
    /// Both lines of code have the same effect. They both invoke the placeOrder method from the checkoutService and wrap the result with the AsyncValue.guard function. The only difference is that in the first line, the method is invoked directly, while in the second line, it's invoked inside an anonymous function that's passed as an argument to the AsyncValue.guard function.
    /// In general, the result should be the same, regardless of which line of code is used.
    state = await AsyncValue.guard(() => checkoutService.placeOrder());
  }
}


final paymentControllerProvider = StateNotifierProvider<PaymentController, AsyncValue<void>>((ref) {
  return PaymentController(ref: ref);
});
