import 'package:ecommerce_app_miki/src/features/cart/domain/item_model.dart';
import 'package:ecommerce_app_miki/src/features/orders/orders_list/order_item_list_tile.dart';
import 'package:ecommerce_app_miki/src/features/orders/orders_list/orders_status_label.dart';
import 'package:ecommerce_app_miki/src/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderCard extends StatelessWidget {
  final Order order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey[400]!, width: 1),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        children: [
          OrderHeader(order: order),
          const Divider(height: 1, color: Colors.grey),
          OrderItemsList(order: order),
        ],
      ),
    );
  }
}

class OrderHeader extends StatelessWidget {
  final Order order;

  const OrderHeader({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final totalFormatted = NumberFormat.simpleCurrency().format(order.total);
    final dateFormatted = DateFormat.yMMMd().format(order.orderDate);

    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order placed'.toUpperCase(),
                    style: Theme.of(context).textTheme.caption,
                  ),
                  const SizedBox(height: 4),
                  Text(dateFormatted),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Total'.toUpperCase(),
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.caption,
                  ),
                  const SizedBox(height: 4),
                  Text(totalFormatted),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OrderItemsList extends StatelessWidget {
  final Order order;

  const OrderItemsList({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: OrderStatusLabel(order: order),
        ),
        for (var entry in order.items.entries)
          OrderItemListTile(
            item: Item(productId: entry.key, quantity: entry.value),
          ),
      ],
    );
  }
}
