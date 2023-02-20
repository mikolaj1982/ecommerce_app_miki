import 'package:ecommerce_app_miki/src/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onPressed;
  final int index;

  // * Keys for testing using find.byKey()
  static const productKey = Key('product-card');

  static Key productCardKey(int index) => Key('product-card-$index');

  const ProductCard({
    super.key,
    required this.product,
    this.onPressed,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final priceFormatted = NumberFormat.simpleCurrency().format(product.price);
    return Card(
      key: productKey,
      child: InkWell(
        key: productCardKey(index),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: Image.asset(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      priceFormatted,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
