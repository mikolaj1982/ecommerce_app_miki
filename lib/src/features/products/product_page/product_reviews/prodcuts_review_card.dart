import 'package:ecommerce_app_miki/src/models/review_model.dart';
import 'package:flutter/material.dart';

class ProductReviewCard extends StatelessWidget {
  final Review review;

  const ProductReviewCard({
    Key? key,
    required this.review,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              review.comment,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  review.score.toString(),
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                const SizedBox(width: 8),
                Text(
                  review.date.toString(),
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
