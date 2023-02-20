import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductRatingBar extends StatelessWidget {
  final double initialRating;
  final ValueChanged<double> onRatingChanged;

  // if true widget won't be interactive
  final bool ignoreGestures;
  final double itemSize;

  const ProductRatingBar({
    Key? key,
    required this.initialRating,
    this.itemSize = 40,
    required this.onRatingChanged,
    this.ignoreGestures = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      itemSize: itemSize,
      ignoreGestures: ignoreGestures,
      initialRating: initialRating,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        onRatingChanged(rating);
      },
    );
  }
}
