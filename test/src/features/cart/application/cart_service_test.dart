import 'package:ecommerce_app_miki/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app_miki/src/features/authentication/domain/app_user_model.dart';
import 'package:ecommerce_app_miki/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app_miki/src/features/cart/data/local/local_cart_repo.dart';
import 'package:ecommerce_app_miki/src/features/cart/data/remote/remote_cart_repo.dart';
import 'package:ecommerce_app_miki/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app_miki/src/features/cart/domain/item_model.dart';
import 'package:ecommerce_app_miki/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';

void main() {
  late MockAuthRepository authRepository;
  late MockRemoteCartRepository remoteCartRepository;
  late MockLocalCartRepository localCartRepository;
  late CartService cartService;
  const testUser = AppUser(
    uid: '123',
  );

  setUp(() {
    authRepository = MockAuthRepository();
    remoteCartRepository = MockRemoteCartRepository();
    localCartRepository = MockLocalCartRepository();
  });

  /// note that if we use any() for arguments of custom types, we need to register a fallback value
  setUpAll(() {
    registerFallbackValue(const Cart());
  });

  CartService makeCartService() {
    /// using the container object we can read any of the providers
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepository),
        remoteCartRepoProvider.overrideWithValue(remoteCartRepository),
        localCartRepoProvider.overrideWithValue(localCartRepository),
      ],
    );

    /// just to show usage of any provider in unit tests
    final currProvider = container.read(currencyFormatterProvider);
    debugPrint('currProvider: $currProvider');

    /// important to dispose the container
    addTearDown(container.dispose);
    return container.read(cartServiceProvider);
  }

  group('setItem', () {
    test('null user, writes to local cart', () async {
      cartService = makeCartService();
      const expectedCart = Cart({'1': 1});
      when(() => authRepository.currentUser).thenReturn(null);
      when(() => localCartRepository.fetchCart()).thenAnswer((_) => Future.value(const Cart()));
      when(() => localCartRepository.setCart(expectedCart)).thenAnswer((_) => Future.value());

      await cartService.setItem(const Item(productId: '1', quantity: 1));

      verify(() => localCartRepository.setCart(expectedCart)).called(1);
      verifyNever(() => remoteCartRepository.setCart(any(), any()));
    });

    test('non-null user, writes to remote cart', () async {
      cartService = makeCartService();
      const expectedCart = Cart({'1': 1});
      when(() => authRepository.currentUser).thenReturn(testUser);
      when(() => remoteCartRepository.fetchCart(testUser.uid)).thenAnswer((_) => Future.value(const Cart()));
      when(() => remoteCartRepository.setCart(testUser.uid, expectedCart)).thenAnswer((_) => Future.value());

      await cartService.setItem(const Item(productId: '1', quantity: 1));

      verify(() => remoteCartRepository.setCart(testUser.uid, expectedCart)).called(1);
      verifyNever(() => localCartRepository.setCart(any()));
    });
  });

  group('addItem', () {
    test('null user, adds items to local cart', () async {
      cartService = makeCartService();
      const initialCart = Cart({'milk': 113});
      const expectedCart = Cart({'milk': 126});
      when(() => authRepository.currentUser).thenReturn(null);
      when(() => localCartRepository.fetchCart()).thenAnswer((_) => Future.value(initialCart));
      when(() => localCartRepository.setCart(expectedCart)).thenAnswer((_) => Future.value());

      await cartService.addItem(const Item(productId: 'milk', quantity: 13));

      verify(() => localCartRepository.setCart(expectedCart)).called(1);
      verifyNever(() => remoteCartRepository.setCart(any(), any()));
    });

    test('non-null user, adds items to local cart', () async {
      cartService = makeCartService();
      const initialCart = Cart({'milk': 113});
      const expectedCart = Cart({'milk': 658});
      when(() => authRepository.currentUser).thenReturn(testUser);
      when(() => remoteCartRepository.fetchCart(testUser.uid)).thenAnswer((_) => Future.value(initialCart));
      when(() => remoteCartRepository.setCart(testUser.uid, expectedCart)).thenAnswer((_) => Future.value());

      await cartService.addItem(const Item(productId: 'milk', quantity: 545));

      verify(() => remoteCartRepository.setCart(testUser.uid, expectedCart)).called(1);
      verifyNever(() => localCartRepository.setCart(any()));
    });
  });

  group('removeItem', () {
    test('null user, removes item from local cart', () async {
      cartService = makeCartService();

      const initialCart = Cart({'milk': 113, 'bread': 1});
      const expectedCart = Cart({'bread': 1});
      when(() => authRepository.currentUser).thenReturn(null);
      when(() => localCartRepository.fetchCart()).thenAnswer((_) => Future.value(initialCart));
      when(() => localCartRepository.setCart(expectedCart)).thenAnswer((_) => Future.value());

      await cartService.removeItemById('milk');

      verify(() => localCartRepository.setCart(expectedCart)).called(1);
      verifyNever(() => remoteCartRepository.setCart(any(), any()));
    });

    test('null user, removes item from remote cart', () async {
      cartService = makeCartService();

      const initialCart = Cart({'milk': 113, 'bread': 1});
      const expectedCart = Cart({'milk': 113});
      when(() => authRepository.currentUser).thenReturn(testUser);
      when(() => remoteCartRepository.fetchCart(testUser.uid)).thenAnswer((_) => Future.value(initialCart));
      when(() => remoteCartRepository.setCart(testUser.uid, expectedCart)).thenAnswer((_) => Future.value());

      await cartService.removeItemById('bread');
      verify(() => remoteCartRepository.setCart(testUser.uid, expectedCart)).called(1);
      verifyNever(() => localCartRepository.setCart(any()));
    });
  });
}
