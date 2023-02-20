import 'package:ecommerce_app_miki/src/features/cart/domain/item_model.dart';
import 'package:ecommerce_app_miki/src/models/order_model.dart';
import 'package:ecommerce_app_miki/src/models/product_model.dart';
import 'package:ecommerce_app_miki/src/models/review_model.dart';

final hardcodedOrders = [
  Order(
    id: 'abc',
    userId: '123',
    items: {
      '1': 1,
      '2': 2,
      '3': 3,
    },
    orderStatus: OrderStatus.delivered,
    orderDate: DateTime(2021, 1, 1),
    total: 104,
  ),
  Order(
    id: 'abc',
    userId: '123',
    items: {
      '1': 1,
      '2': 2,
      '3': 3,
    },
    orderStatus: OrderStatus.delivered,
    orderDate: DateTime(2021, 1, 1),
    total: 104,
  ),
  Order(
    id: 'abc',
    userId: '123',
    items: {
      '1': 1,
      '2': 2,
      '3': 3,
    },
    orderStatus: OrderStatus.delivered,
    orderDate: DateTime(2021, 1, 1),
    total: 104,
  ),
  Order(
    id: 'abc',
    userId: '123',
    items: {
      '1': 1,
      '2': 2,
      '3': 3,
    },
    orderStatus: OrderStatus.delivered,
    orderDate: DateTime(2021, 1, 1),
    total: 104,
  ),
];

const shoppingCartItems = [
  Item(
    productId: '1',
    quantity: 1,
  ),
  Item(
    productId: '2',
    quantity: 2,
  ),
  Item(
    productId: '3',
    quantity: 3,
  ),
];

final testReviews = [
  Review(
    rating: 5,
    comment: 'Great product, would buy again!',
    date: DateTime(2022, 2, 12),
  ),
  Review(
    rating: 4,
    comment: 'Looks great but the packaging was damaged.',
    date: DateTime(2022, 2, 10),
  ),
  Review(
    rating: 5,
    comment: 'Great product, would buy again!',
    date: DateTime(2022, 2, 12),
  ),
  Review(
    rating: 4,
    comment: 'Looks great but the packaging was damaged.',
    date: DateTime(2022, 2, 10),
  ),
];

final testProducts = [
  Product(
    id: '1',
    imageUrl: 'assets/products/bruschetta-plate.jpg',
    title: 'Bruschetta plate',
    description: 'Lorem ipsum',
    price: 15,
    availableQuantity: 5,
  ),
  Product(
    id: '2',
    imageUrl: 'assets/products/mozzarella-plate.jpg',
    title: 'Mozzarella plate',
    description: 'Lorem ipsum',
    price: 13,
    availableQuantity: 5,
  ),
  Product(
    id: '3',
    imageUrl: 'assets/products/pasta-plate.jpg',
    title: 'Pasta plate',
    description: 'Lorem ipsum',
    price: 17,
    availableQuantity: 5,
  ),
  Product(
    id: '4',
    imageUrl: 'assets/products/piggy-blue.jpg',
    title: 'Piggy Bank Blue',
    description: 'Lorem ipsum',
    price: 12,
    availableQuantity: 5,
  ),
  Product(
    id: '5',
    imageUrl: 'assets/products/piggy-green.jpg',
    title: 'Piggy Bank Green',
    description: 'Lorem ipsum',
    price: 12,
    availableQuantity: 10,
  ),
  Product(
    id: '6',
    imageUrl: 'assets/products/piggy-pink.jpg',
    title: 'Piggy Bank Pink',
    description: 'Lorem ipsum',
    price: 12,
    availableQuantity: 10,
  ),
  Product(
    id: '7',
    imageUrl: 'assets/products/pizza-plate.jpg',
    title: 'Pizza plate',
    description: 'Lorem ipsum',
    price: 18,
    availableQuantity: 10,
  ),
  Product(
    id: '8',
    imageUrl: 'assets/products/plate-and-bowl.jpg',
    title: 'Plate and Bowl',
    description: 'Lorem ipsum',
    price: 21,
    availableQuantity: 10,
  ),
  Product(
    id: '9',
    imageUrl: 'assets/products/salt-pepper-lemon.jpg',
    title: 'Salt and pepper lemon',
    description: 'Lorem ipsum',
    price: 11,
    availableQuantity: 10,
  ),
  Product(
    id: '10',
    imageUrl: 'assets/products/salt-pepper-olives.jpg',
    title: 'Salt and pepper olives',
    description: 'Lorem ipsum',
    price: 11,
    availableQuantity: 10,
  ),
  Product(
    id: '11',
    imageUrl: 'assets/products/snacks-plate.jpg',
    title: 'Snacks plate',
    description: 'Lorem ipsum',
    price: 24,
    availableQuantity: 10,
  ),
  Product(
    id: '12',
    imageUrl: 'assets/products/flowers-plate.jpg',
    title: 'Flowers plate',
    description: 'Lorem ipsum',
    price: 22,
    availableQuantity: 10,
  ),
  Product(
    id: '13',
    imageUrl: 'assets/products/juicer-citrus-fruits.jpg',
    title: 'Juicer for citrus fruits',
    description: 'Lorem ipsum',
    price: 14,
    availableQuantity: 10,
  ),
  Product(
    id: '14',
    imageUrl: 'assets/products/honey-pot.jpg',
    title: 'Honey pot',
    description: 'Lorem ipsum',
    price: 16,
    availableQuantity: 10,
  ),
];
