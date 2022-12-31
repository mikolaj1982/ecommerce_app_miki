import 'package:ecommerce_app_miki/src/common_widgets/responsive_center.dart';
import 'package:ecommerce_app_miki/src/constants/test_products.dart';
import 'package:ecommerce_app_miki/src/features/products/product_page/product_reviews/prodcuts_review_card.dart';
import 'package:ecommerce_app_miki/src/models/review_model.dart';
import 'package:flutter/material.dart';

class ProductReviewsList extends StatelessWidget {
  const ProductReviewsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Review> reviews = testReviews;

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return ResponsiveCenter(
            maxContentWidth: 600,
            child: ProductReviewCard(review: reviews[index]),
          );
        },
        childCount: reviews.length,
        // 40 list items
      ),
    );
  }
}
