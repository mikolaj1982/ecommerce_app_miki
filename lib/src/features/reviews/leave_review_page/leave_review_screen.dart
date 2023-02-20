import 'package:ecommerce_app_miki/src/common_widgets/primary_button.dart';
import 'package:ecommerce_app_miki/src/common_widgets/responsive_center.dart';
import 'package:ecommerce_app_miki/src/common_widgets/typedefs.dart';
import 'package:ecommerce_app_miki/src/features/products/product_page/product_reviews/product_rating_bar.dart';
import 'package:ecommerce_app_miki/src/features/reviews/leave_review_controller.dart';
import 'package:ecommerce_app_miki/src/features/reviews/review_service.dart';
import 'package:ecommerce_app_miki/src/models/review_model.dart';
import 'package:ecommerce_app_miki/src/utils/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LeaveReviewScreen extends ConsumerWidget {
  final ProductID productId;

  const LeaveReviewScreen({
    Key? key,
    required this.productId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<Review?> review = ref.watch(userReviewProvider(productId));
    final state = ref.watch(leaveReviewControllerProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => state.isLoading ? null : context.pop(),
        ),
        title: const Text('Leave a review'),
      ),
      body: ResponsiveCenter(
        maxContentWidth: 600,
        padding: const EdgeInsets.all(16),
        child: review.when(
          data: (review) {
            return LeaveReviewForm(
              productId: productId,
              review: review,
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (error, stack) => Text('Error: $error'),
        ),
      ),
    );
  }
}

class LeaveReviewForm extends ConsumerStatefulWidget {
  final ProductID productId;
  final Review? review;

  const LeaveReviewForm({
    Key? key,
    required this.productId,
    this.review,
  }) : super(key: key);

  @override
  ConsumerState<LeaveReviewForm> createState() => _LeaveReviewFormState();
}

class _LeaveReviewFormState extends ConsumerState<LeaveReviewForm> {
  final _controller = TextEditingController();
  double _rating = 0;

  @override
  void initState() {
    super.initState();
    final review = widget.review;
    if (review != null) {
      _controller.text = review.comment;
      _rating = review.rating;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(leaveReviewControllerProvider);
    ref.listen<AsyncValue>(
      leaveReviewControllerProvider,
      (_, state) => state.showSnackBarOnError(context),
    );
    return Column(
      children: [
        if (widget.review != null) ...[
          const Text(
            'You have already left a review for this product. Submit again to edit.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24.0),
        ],
        const Text('Rating'),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('1'),
            const SizedBox(width: 8),
            ProductRatingBar(
                initialRating: _rating,
                onRatingChanged: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                }),
            const SizedBox(width: 8),
            const Text('5'),
          ],
        ),
        const SizedBox(height: 16),
        const Text('Comment'),
        const SizedBox(height: 8),
        TextField(
          key: const Key('reviewComment'),
          controller: _controller,
          maxLines: 5,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        PrimaryButton(
          text: 'Submit',
          isLoading: state.isLoading,
          onPressed: state.isLoading || _rating == 0
              ? null
              : () {
                  ref.read(leaveReviewControllerProvider.notifier).submitReview(
                        previousReview: widget.review,
                        productId: widget.productId,
                        rating: _rating,
                        comment: _controller.text,
                        onSuccess: context.pop,
                      );
                },
        ),
      ],
    );
  }
}
