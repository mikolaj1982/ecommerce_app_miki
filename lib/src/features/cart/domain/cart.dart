// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:ecommerce_app_miki/src/common_widgets/typedefs.dart';
import 'package:flutter/foundation.dart';

import 'item_model.dart';

/// Model class representing a shopping cart contents.
class Cart {
  const Cart([this.items = const {}]);

  /// all the items in the cart where
  /// - key: productID
  /// - value: quantity
  final Map<ProductID, int> items;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'items': items,
    };
  }

  factory Cart.fromMap(Map<String, dynamic> json) {
    final items = json['items'] as Map<String, dynamic>;
    return Cart(Map<ProductID, int>.from(items));
  }

  String toJson() => json.encode(toMap());

  factory Cart.fromJson(String source) => Cart.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant Cart other) {
    if (identical(this, other)) return true;

    return mapEquals(other.items, items);
  }

  @override
  int get hashCode => items.hashCode;

  Cart merge(Cart localCart) {
    final newItems = <ProductID, int>{};
    newItems.addAll(items);
    localCart.items.forEach((key, value) {
      if (newItems.containsKey(key)) {
        newItems[key] = newItems[key]! + value;
      } else {
        newItems[key] = value;
      }
    });
    return Cart(newItems);
  }

  containsItemWithId(ProductID productId) {
    return items.containsKey(productId);
  }
}

extension CartItems on Cart {
  List<Item> toItemsList() {
    return items.entries.map((e) => Item(productId: e.key, quantity: e.value)).toList();
  }
}
