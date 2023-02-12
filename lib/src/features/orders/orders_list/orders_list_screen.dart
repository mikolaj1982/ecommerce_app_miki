import 'package:ecommerce_app_miki/src/common_widgets/async_value_widget.dart';
import 'package:ecommerce_app_miki/src/common_widgets/responsive_center.dart';
import 'package:ecommerce_app_miki/src/features/orders/orders_list/order_card.dart';
import 'package:ecommerce_app_miki/src/features/orders/user_orders_provider.dart';
import 'package:ecommerce_app_miki/src/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrdersListScreen extends ConsumerWidget {
  const OrdersListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Order>> ordersValue = ref.watch(userOrdersProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      body: AsyncValueWidget<List<Order>>(
          value: ordersValue,
          data: (orders) {
            if(orders.isEmpty){
              return Center(
                child: Text(
                  'No previous orders',
                  style: Theme.of(context).textTheme.displaySmall,
                  textAlign: TextAlign.center,
                ),
              );
            }
            return CustomScrollView(
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
            );
          }),
    );
  }
}
