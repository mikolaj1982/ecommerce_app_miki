// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ecommerce_app_miki/src/common_widgets/typedefs.dart';

class Item {
  final ProductID productId;
  final int quantity;

  const Item({
    required this.productId,
    required this.quantity,
  });

  @override
  String toString() => 'Item(productId: $productId, quantity: $quantity)';

  @override
  bool operator ==(covariant Item other) {
    if (identical(this, other)) return true;
  
    return 
      other.productId == productId &&
      other.quantity == quantity;
  }

  @override
  int get hashCode => productId.hashCode ^ quantity.hashCode;
}
