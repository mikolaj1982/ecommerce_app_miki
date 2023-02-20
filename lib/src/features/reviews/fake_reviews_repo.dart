import 'package:ecommerce_app_miki/src/common_widgets/typedefs.dart';
import 'package:ecommerce_app_miki/src/models/review_model.dart';
import 'package:ecommerce_app_miki/src/utils/delay.dart';
import 'package:ecommerce_app_miki/src/utils/in_memory_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// read and write the review data
class FakeReviewsRepository {
  final bool addDelay;

  /// talks to backend
  FakeReviewsRepository({this.addDelay = true});

  /// Reviews store
  /// key: [ProductID]
  /// value: map of [Review] values for each user ID
  final _reviews = InMemoryStore<Map<ProductID, Map<String, Review>>>({});

  /// Single review for a given product given by a specific user
  /// emits non-null values if the user has reviewed the product
  Stream<Review?> watchUserReview(ProductID id, String uid) {
    return _reviews.stream.map((reviews) {
      final productReviews = reviews[id] ?? {};
      return productReviews[uid];
    });
  }

  /// All reviews for a given product from all users
  Stream<List<Review>> watchReviews(ProductID id) {
    return _reviews.stream.map((reviews) {
      final productReviews = reviews[id] ?? {};
      return productReviews.values.toList();
    });
  }

  /// All reviews for a given product from all users
  Future<List<Review>> fetchReviews(ProductID productId) {
    final allReviews = _reviews.value[productId];
    if (allReviews == null) {
      return Future.value([]);
    } else {
      return Future.value(allReviews.values.toList());
    }
  }

  /// Submit a new review or update an existing review for a given product
  /// @param productId the product identifier
  /// @param uid the identifier of the user who is leaving the review
  /// @param review a [Review] object with the review information
  Future<void> setReview({
    required ProductID productId,
    required String uid,
    required Review review,
  }) async {
    await delay(addDelay);
    final allReviews = _reviews.value;
    final productReviews = allReviews[productId] ?? {};
    productReviews[uid] = review;
    allReviews[productId] = productReviews;
    _reviews.value = allReviews;
  }
}

final reviewsRepoProvider = Provider<FakeReviewsRepository>((ref) {
  return FakeReviewsRepository();
});
