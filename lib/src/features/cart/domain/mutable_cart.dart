import 'package:ecommerce_app_miki/src/common_widgets/typedefs.dart';
import 'package:flutter/material.dart';

import 'cart.dart';
import 'item_model.dart';

extension MutableCart on Cart {
  // set item
  Cart setItem(Item item) {
    final copy = Map<ProductID, int>.from(items);
    copy[item.productId] = item.quantity;
    return Cart(copy);
  }

  Cart addItem(Item item) {
    debugPrint('quantity: ${item.quantity}');
    final copy = Map<ProductID, int>.from(items);
    if (copy.containsKey(item.productId)) {
      copy[item.productId] = (copy[item.productId] ?? 0) + item.quantity;
    } else {
      copy[item.productId] = item.quantity;
    }
    return Cart(copy);
  }

  // add multiple items to cart
  Cart addItems(List<Item> items) {
    debugPrint('addItems: $items');
    var copy = Map<ProductID, int>.from(this.items);
    for (final item in items) {
      copy[item.productId] = (copy[item.productId] ?? 0) + item.quantity;
    }
    return Cart(copy);
  }

  // remove item from cart by productID
  Cart removeItemById(ProductID productId) {
    debugPrint('removeItem: $productId');
    final copy = Map<ProductID, int>.from(items);
    copy.remove(productId);
    return Cart(copy);
  }

  // update item if it exists in cart
  Cart updateItemIfExists(Item item) {
    debugPrint('updateItemIfExists: $item');
    if (items.containsKey(item.productId)) {
      final copy = Map<ProductID, int>.from(items);
      copy[item.productId] = item.quantity;
      return Cart(copy);
    } else {
      return this;
    }
  }

  // clear cart
  Cart clear() {
    return const Cart({});
  }
}
