enum OrderStatus {
  confirmed,
  shipped,
  delivered,
}

class Order {
  final String id;
  final String userId;
  final Map<String, int> items;
  final OrderStatus orderStatus;
  final DateTime orderDate;
  final double total;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.orderStatus,
    required this.orderDate,
    required this.total,
  });
}
