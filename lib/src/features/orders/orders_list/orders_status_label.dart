import 'package:ecommerce_app_miki/src/models/order_model.dart';
import 'package:flutter/material.dart';

class OrderStatusLabel extends StatelessWidget {
  final Order order;

  const OrderStatusLabel({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyText1!;
    switch (order.orderStatus) {
      case OrderStatus.confirmed:
        return Text(
          'Confirmed',
          style: textStyle,
        );
      case OrderStatus.shipped:
        return Text(
          'Shipped',
          style: textStyle,
        );
      case OrderStatus.delivered:
        return Text(
          'Delivered',
          style: textStyle.copyWith(color: Colors.green),
        );
      default:
        return Text(
          'Unknown',
          style: textStyle.copyWith(color: Colors.red),
        );
    }
  }
}
