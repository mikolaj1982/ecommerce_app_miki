import 'package:ecommerce_app_miki/src/common_widgets/typedefs.dart';
import 'package:ecommerce_app_miki/src/constants/test_products.dart';
import 'package:ecommerce_app_miki/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app_miki/src/features/authentication/domain/app_user_model.dart';
import 'package:ecommerce_app_miki/src/features/cart/application/cart_sync_service.dart';
import 'package:ecommerce_app_miki/src/features/cart/data/local/local_cart_repo.dart';
import 'package:ecommerce_app_miki/src/features/cart/data/remote/remote_cart_repo.dart';
import 'package:ecommerce_app_miki/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app_miki/src/features/products/providers/products_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';

void main() {
  late MockAuthRepository authRepository;
  late MockRemoteCartRepository remoteCartRepository;
  late MockLocalCartRepository localCartRepository;
  // late MockProductsRepository productsRepository;

  setUp(() {
    authRepository = MockAuthRepository();
    remoteCartRepository = MockRemoteCartRepository();
    localCartRepository = MockLocalCartRepository();
    // productsRepository = MockProductsRepository();
  });

  CartSyncService makeCartSyncService() {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepository),
        remoteCartRepoProvider.overrideWithValue(remoteCartRepository),
        localCartRepoProvider.overrideWithValue(localCartRepository),
        // productsRepoProvider.overrideWithValue(productsRepository),
      ],
    );
    addTearDown(container.dispose);
    return container.read(cartSyncServiceProvider);
  }

  group('CartSyncService', () {
    Future<void> runCartSyncTest({
      required Map<ProductID, int> localCart,
      required Map<ProductID, int> remoteCart,
      required Map<ProductID, int> expectedRemoteCartItems,
    }) async {
      const uid = 'd036a8d0-9b77-11ed-a549-4989f1f94381';
      const user = AppUser(
        uid: uid,
        email: 'test@test.com',
      );

      /// the state changes for logged user
      when(authRepository.authStateChanges).thenAnswer((_) => Stream.value(user));
      // when(productsRepository.fetchProductsList).thenAnswer((_) => Future.value(testProducts));
      when(localCartRepository.fetchCart).thenAnswer((_) => Future.value(Cart(localCart)));
      when(() => remoteCartRepository.fetchCart(uid)).thenAnswer((_) => Future.value(Cart(remoteCart)));
      when(() => remoteCartRepository.setCart(uid, Cart(expectedRemoteCartItems))).thenAnswer((_) => Future.value());
      when(() => localCartRepository.setCart(const Cart())).thenAnswer((_) => Future.value());

      // create cart sync service (return value not needed)
      makeCartSyncService();

      // wait for all the stubbed methods to return a value
      await Future.delayed(const Duration());

      // verify
      verify(() => remoteCartRepository.setCart(uid, Cart(expectedRemoteCartItems))).called(1);
      verify(() => localCartRepository.setCart(const Cart())).called(1);
    }

    test('local quantity <= available quantity', () async {
      await runCartSyncTest(
        localCart: {'1': 1},
        remoteCart: {},
        expectedRemoteCartItems: {'1': 1},
      );
    });

    test('local quantity > available quantity', () async {
      await runCartSyncTest(
        localCart: {'1': 15},
        remoteCart: {},
        expectedRemoteCartItems: {'1': 15},
      );
    });

    test('local + remote quantity <= available quantity', () async {
      await runCartSyncTest(
        localCart: {'1': 2},
        remoteCart: {'1': 3},
        expectedRemoteCartItems: {'1': 5},
      );
    });

    test('local + remote quantity > available quantity', () async {
      await runCartSyncTest(
        localCart: {'1': 10},
        remoteCart: {'1': 10},
        expectedRemoteCartItems: {'1': 20},
      );
    });

    test('multiple items', () async {
      await runCartSyncTest(
        localCart: {'1': 3, '2': 1, '3': 2},
        remoteCart: {'1': 3},
        expectedRemoteCartItems: {'1': 6, '2': 1, '3': 2},
      );
    });
  });
}
