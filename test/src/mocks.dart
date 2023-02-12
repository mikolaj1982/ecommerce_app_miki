import 'package:ecommerce_app_miki/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app_miki/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app_miki/src/features/cart/data/local/local_cart_repo.dart';
import 'package:ecommerce_app_miki/src/features/cart/data/remote/remote_cart_repo.dart';
import 'package:ecommerce_app_miki/src/features/checkout/payment/checkout_service.dart';
import 'package:ecommerce_app_miki/src/features/orders/fake_orders_repository.dart';
import 'package:ecommerce_app_miki/src/features/products/data/fake_products_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements FakeAuthRepository {}

class MockRemoteCartRepository extends Mock implements RemoteCartRepository {}

class MockLocalCartRepository extends Mock implements LocalCartRepository {}

class MockProductsRepository extends Mock implements FakeProductsRepository {}

class MockCartService extends Mock implements CartService {}

class MockCheckoutService extends Mock implements FakeCheckoutService {}

class MockOrderRepository extends Mock implements FakeOrdersRepository {}

class Listener<T> extends Mock {
  void call(T? previous, T next);
}
