import 'package:ecommerce_app_miki/src/common_widgets/typedefs.dart';
import 'package:ecommerce_app_miki/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app_miki/src/features/products/providers/products_provider.dart';
import 'package:ecommerce_app_miki/src/models/review_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'fake_reviews_repo.dart';

class ReviewService {
  ReviewService(this.ref);

  final Ref ref;

  Future<void> submitReview(ProductID productId, Review review) async {
    final user = ref.watch(authStateChangesProvider).value;

    /// we should only allow for leaving review when the user is signed in
    if (user == null) {
      throw AssertionError('Can\'t submit a review if the user is not signed in');
    }

    await ref.read(reviewsRepoProvider).setReview(
          productId: productId,
          uid: user.uid,
          review: review,
        );
    _updateProductRating(productId);
  }

  void _updateProductRating(ProductID productId)async {
    final productToUpdate = await ref.read(productsRepoProvider).getProductByID(productId);
    if (productToUpdate == null) {
      throw StateError('Product not found with id: $productId.');
    }

    final reviews = await ref.read(reviewsRepoProvider).fetchReviews(productId);
    final avgRating = _avgReviewScore(reviews);
    final updatedProduct = productToUpdate.copyWith(
      avgRating: avgRating,
      numRatings: reviews.length,
    );
    await ref.read(productsRepoProvider).setProduct(updatedProduct);
  }

  double _avgReviewScore(List<Review> reviews) {
    if (reviews.isEmpty) {
      return 0;
    }
    var total = 0.0;
    for (var review in reviews) {
      total += review.rating;
    }
    return total / reviews.length;
  }
}

final reviewServiceProvider = Provider<ReviewService>((ref) {
  return ReviewService(ref);
});

// check if product was previously reviews by the user
final userReviewProvider = StreamProvider.family.autoDispose<Review?, ProductID>((ref, productId) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user == null) {
    return Stream.value(null);
  }
  return ref.watch(reviewsRepoProvider).watchUserReview(productId, user.uid);
});


final userReviewFutureProvider = FutureProvider.family.autoDispose<Review?, ProductID>((ref, productId) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user == null) {
    return Future.value(null);
  }
  return ref.watch(reviewsRepoProvider).watchUserReview(productId, user.uid).first;
});


final productReviewsProvider = StreamProvider.family.autoDispose<List<Review>, ProductID>((ref, productId) {
  return ref.watch(reviewsRepoProvider).watchReviews(productId);
});
