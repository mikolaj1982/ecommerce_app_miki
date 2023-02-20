import 'package:ecommerce_app_miki/src/common_widgets/async_value_widget.dart';
import 'package:ecommerce_app_miki/src/common_widgets/responsive_center.dart';
import 'package:ecommerce_app_miki/src/common_widgets/typedefs.dart';
import 'package:ecommerce_app_miki/src/features/products/product_page/product_reviews/prodcuts_review_card.dart';
import 'package:ecommerce_app_miki/src/features/reviews/review_service.dart';
import 'package:ecommerce_app_miki/src/models/review_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductReviewsList extends ConsumerWidget {
  final ProductID productId;

  const ProductReviewsList({
    Key? key,
    required this.productId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// get all reviews by productId
    final AsyncValue<List<Review>> reviews = ref.watch(productReviewsProvider(productId));
    return AsyncValueSliverWidget(
      value: reviews,
      data: (reviews) {
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
      },
    );
  }
}
