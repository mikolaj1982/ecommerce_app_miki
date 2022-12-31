import 'package:ecommerce_app_miki/src/constants/test_products.dart';
import 'package:ecommerce_app_miki/src/features/products/data/fake_products_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  FakeProductsRepository getRepo() {
    return FakeProductsRepository(addDelay: false);
  }

  group('FakeProductsRepository', () {
    test('getProductsList return global products list', () {
      final repo = getRepo();
      expect(
        repo.getProductsList(),
        testProducts,
      );
    });

    test('getProduct(1) returns first item', () {
      final repo = getRepo();
      expect(
        repo.getProductById('1'),
        testProducts[0],
      );
    });

    test('getProduct(100) returns null', () {
      final repo = getRepo();
      expect(
        repo.getProductById('100'),
        null,
      );
    });

    /// to evaluate whole expression before compare with matcher,
    /// we use the arrow function () => repo.getProductById('100'),
    // test('throw state error', () {
    //   final repo = FakeProductsRepository();
    //   expect(
    //     () => repo.getProductById('100'),
    //     throwsStateError,
    //   );
    // });
  });

  group('FakeProductsRepository futures', () {
    test('fetchProductsList', () async {
      final repo = getRepo();
      expect(
        await repo.fetchProductsList(),
        testProducts,
      );
    });

    /// testing future using await
    test('fetchProductsListWithError', () async {
      final repo = getRepo();
      expect(
        repo.fetchProductsListWithError(),
        throwsException,
      );
    });

    /// testing streams using emits
    test('watchProductsList', () async {
      final repo = getRepo();
      expect(
        repo.watchProductsList(),
        emits(testProducts),
      );
    });

    test('watchProduct id=1', () async {
      final repo = getRepo();
      expect(
        repo.watchProduct('1'),
        emits(testProducts[0]),
      );
    });

    test('watchProduct id=100', () async {
      final repo = getRepo();
      expect(
        repo.watchProduct('100'),
        emits(null),
      );
    });
  });
}
