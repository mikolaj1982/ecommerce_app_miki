import 'package:ecommerce_app_miki/src/models/product_model.dart';
import 'package:flutter/material.dart';

/// shows product average rating and the number of ratings
class ProductAverageRating extends StatelessWidget {
  final Product product;

  const ProductAverageRating({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.star,
          color: Colors.amber,
        ),
        const SizedBox(width: 8),
        Text(
          product.avgRating.toStringAsFixed(1),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(width: 8),
        Text(
          '(${product.numRatings})',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
