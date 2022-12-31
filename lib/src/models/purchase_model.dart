import 'package:ecommerce_app_miki/src/common_widgets/typedefs.dart';

class Purchase {
  final OrderID orderId;
  final DateTime orderDate;

  const Purchase({
    required this.orderId,
    required this.orderDate,
  });
}
