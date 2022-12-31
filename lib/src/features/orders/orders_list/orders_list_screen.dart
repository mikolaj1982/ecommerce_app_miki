import 'package:ecommerce_app_miki/src/common_widgets/responsive_center.dart';
import 'package:ecommerce_app_miki/src/constants/test_products.dart';
import 'package:ecommerce_app_miki/src/features/orders/orders_list/order_card.dart';
import 'package:ecommerce_app_miki/src/models/order_model.dart';
import 'package:flutter/material.dart';

class OrdersListScreen extends StatelessWidget {
  const OrdersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Order> orders = hardcodedOrders;
    // trace info

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return ResponsiveCenter(
                  padding: const EdgeInsets.all(8),
                  child: OrderCard(order: orders[index]),
                );
              },
              childCount: orders.length,
            ),
          ),
        ],
      ),
    );
  }
}
