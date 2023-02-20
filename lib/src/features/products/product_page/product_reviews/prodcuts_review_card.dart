import 'package:ecommerce_app_miki/src/features/products/product_page/product_reviews/product_rating_bar.dart';
import 'package:ecommerce_app_miki/src/models/review_model.dart';
import 'package:ecommerce_app_miki/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductReviewCard extends ConsumerWidget {
  final Review review;

  const ProductReviewCard({
    Key? key,
    required this.review,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormatted = ref.watch(dateFormatterProvider).format(review.date);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ProductRatingBar(
                  itemSize: 20,
                  ignoreGestures: true,
                  initialRating: review.rating,
                  onRatingChanged: (rating) {},
                ),
                Text(
                  review.rating.toString(),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(width: 8),
                Text(
                  dateFormatted,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            if (review.comment.isNotEmpty) ...[
              const SizedBox(width: 16),
              Text(
                review.comment,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
