import 'package:ecommerce_app_miki/src/common_widgets/primary_button.dart';
import 'package:ecommerce_app_miki/src/common_widgets/responsive_center.dart';
import 'package:ecommerce_app_miki/src/common_widgets/typedefs.dart';
import 'package:ecommerce_app_miki/src/features/products/product_page/product_reviews/product_rating_bar.dart';
import 'package:ecommerce_app_miki/src/models/review_model.dart';
import 'package:flutter/material.dart';

class LeaveReviewScreen extends StatelessWidget {
  final ProductID productId;

  const LeaveReviewScreen({
    Key? key,
    required this.productId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final review = Review(
      comment: 'This is a comment',
      score: 4,
      date: DateTime.now(),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave a review'),
      ),
      body: ResponsiveCenter(
        maxContentWidth: 600,
        padding: const EdgeInsets.all(16),
        child: LeaveReviewForm(productId: productId, review: review),
      ),
    );
  }
}

class LeaveReviewForm extends StatefulWidget {
  final ProductID productId;
  final Review? review;

  const LeaveReviewForm({
    Key? key,
    required this.productId,
    this.review,
  }) : super(key: key);

  @override
  State<LeaveReviewForm> createState() => _LeaveReviewFormState();
}

class _LeaveReviewFormState extends State<LeaveReviewForm> {
  final _controller = TextEditingController();
  double _rating = 0;

  @override
  void initState() {
    super.initState();
    final review = widget.review;
    if (review != null) {
      _controller.text = review.comment;
      _rating = review.score;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Rating'),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('1'),
            SizedBox(width: 8),
            ProductRatingBar(),
            SizedBox(width: 8),
            Text('5'),
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
          onPressed: () {},
        ),
      ],
    );
  }
}
