import 'package:ecommerce_app_miki/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app_miki/src/features/authentication/domain/app_user_model.dart';
import 'package:ecommerce_app_miki/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app_miki/src/features/cart/data/remote/remote_cart_repo.dart';
import 'package:ecommerce_app_miki/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app_miki/src/features/checkout/payment/checkout_service.dart';
import 'package:ecommerce_app_miki/src/features/orders/fake_orders_repository.dart';
import 'package:ecommerce_app_miki/src/models/order_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';

void main() {
  const testUser = AppUser(
    uid: 'd036a8d0-9b77-11ed-a549-4989f1f94381',
    email: 'test@test.com',
  );
  final testDate = DateTime(2022, 7, 13);

  setUpAll(() {
    // needed for MockOrdersRepository
    registerFallbackValue(Order(
      id: '1',
      userId: testUser.uid,
      items: {'1': 1},
      orderStatus: OrderStatus.confirmed,
      orderDate: testDate,
      total: 15,
    ));
    // needed for MockRemoteCartRepository
    registerFallbackValue(const Cart());
  });

  late MockAuthRepository authRepository;
  late MockRemoteCartRepository remoteCartRepository;
  late MockOrderRepository ordersRepoProvider;

  setUp(() {
    authRepository = MockAuthRepository();
    remoteCartRepository = MockRemoteCartRepository();
    ordersRepoProvider = MockOrderRepository();
  });

  FakeCheckoutService mockCheckoutService() {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepository),
        remoteCartRepoProvider.overrideWithValue(remoteCartRepository),
        fakeOrdersRepoProvider.overrideWithValue(ordersRepoProvider),
        cartTotalProvider.overrideWithValue(15),
      ],
    );

    addTearDown(container.dispose);
    return container.read(checkoutServiceProvider);
  }

  group('placeOrder', () {
    test('null user, throws', () async {
      final service = mockCheckoutService();
      when(() => authRepository.currentUser).thenAnswer((_) => null);
      expect(service.placeOrder(), throwsA(isA<TypeError>()));
    });

    test('empty cart, throws', () async {
      final service = mockCheckoutService();
      when(() => authRepository.currentUser).thenAnswer((_) => testUser);
      when(() => remoteCartRepository.fetchCart(testUser.uid)).thenAnswer((_) => Future.value(const Cart({})));
      expect(service.placeOrder(), throwsStateError);
    });

    test('non-empty cart, creates order and purchase, empties cart', () async {
      final service = mockCheckoutService();
      when(() => authRepository.currentUser).thenAnswer((_) => testUser);
      when(() => remoteCartRepository.fetchCart(testUser.uid)).thenAnswer((_) => Future.value(const Cart({'1': 1})));

      when(() => remoteCartRepository.setCart(testUser.uid, const Cart())).thenAnswer((_) => Future.value());
      when(() => ordersRepoProvider.addOrder(testUser.uid, any())).thenAnswer((_) => Future.value());

      await service.placeOrder();
      verify(() => ordersRepoProvider.addOrder(testUser.uid, any())).called(1);
      verify(() => remoteCartRepository.setCart(testUser.uid, const Cart()))
          .called(1);
    });
  });
}
