import 'package:ecommerce_app_miki/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app_miki/src/features/cart/domain/item_model.dart';
import 'package:ecommerce_app_miki/src/features/cart/domain/mutable_cart.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('set item', () {
    test('empty cart - set item with quantity', () {
      const cart = Cart();
      const item = Item(productId: '1', quantity: 3);
      final updatedCart = cart.setItem(item);
      expect(updatedCart.items, {'1': 3});
    });

    test('cart with same item - override quantity', () {
      final cart = const Cart()
          .addItem(const Item(productId: '1', quantity: 3))
          .setItem(const Item(productId: '1', quantity: 5));
      expect(cart.items, {'1': 5});
    });

    test('cart with different item - add new item', () {
      final cart = const Cart()
          .addItem(const Item(productId: '1', quantity: 3))
          .setItem(const Item(productId: '2', quantity: 5));
      expect(cart.items, {'1': 3, '2': 5});
    });
  });

  group('add item', () {
    test('empty cart - add item with quantity', () {
      const cart = Cart();
      const item = Item(productId: '1', quantity: 3);
      final updatedCart = cart.addItem(item);
      expect(updatedCart.items, {'1': 3});
    });

    test('empty cart - add two items', () {
      const cart = Cart();
      const item = Item(productId: '1', quantity: 3);
      const item2 = Item(productId: '2', quantity: 5);
      final updatedCart = cart.addItem(item).addItem(item2);
      expect(updatedCart.items, {'1': 3, '2': 5});
    });

    test('empty cart - add same item twice', () {
      const cart = Cart();
      const item = Item(productId: '1', quantity: 3);
      final updatedCart = cart.addItem(item).addItem(item);
      expect(updatedCart.items, {'1': 6});
    });
  });

  group('add items', () {
    test('empty cart - add two items', () {
      const cart = Cart();
      const item = Item(productId: '1', quantity: 3);
      const item2 = Item(productId: '2', quantity: 5);
      final updatedCart = cart.addItems([item, item2]);
      expect(updatedCart.items, {'1': 3, '2': 5});
    });

    test('cart with one item - add two items of which one is matching', () {
      const cart = Cart();
      const item = Item(productId: '1', quantity: 3);
      const item2 = Item(productId: '2', quantity: 5);
      const item3 = Item(productId: '1', quantity: 2);
      final updatedCart = cart.addItems([item, item2, item3]);
      expect(updatedCart.items, {'1': 5, '2': 5});
    });

    test('cart with one item - add two new items', () {
      final cart = const Cart().addItem(const Item(productId: '1', quantity: 3)).addItems([
        const Item(productId: '2', quantity: 5),
        const Item(productId: '3', quantity: 2),
      ]);
      expect(cart.items, {
        '1': 3,
        '2': 5,
        '3': 2,
      });
    });
  });

  group('remove item', () {
    test('empty cart - remove item', () {
      const cart = Cart();
      final updatedCart = cart.removeItemById('1');
      expect(updatedCart.items, {});
    });

    test('empty cart - remove matching item', () {
      final cart = const Cart().addItem(const Item(productId: '1', quantity: 3));
      final updatedCart = cart.removeItemById('1');
      expect(updatedCart.items, {});
    });

    test('empty cart - remove non-matching item', () {
      final cart = const Cart().addItem(const Item(productId: '1', quantity: 3));
      final updatedCart = cart.removeItemById('3');
      expect(updatedCart.items, {'1': 3});
    });
  });
}
