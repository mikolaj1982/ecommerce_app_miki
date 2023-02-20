import 'package:ecommerce_app_miki/src/common_widgets/typedefs.dart';
import 'package:ecommerce_app_miki/src/features/reviews/review_service.dart';
import 'package:ecommerce_app_miki/src/models/review_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LeaveReviewController extends StateNotifier<AsyncValue<void>> {
  final ReviewService reviewService;
  final Ref ref;

  /// * this is injected so we can easily mock the date in the tests
  final DateTime Function() currentDateBuilder;

  LeaveReviewController({
    required this.currentDateBuilder,
    required this.ref,
    required this.reviewService,
  }) : super(const AsyncData<void>(null));

  Future<void> submitReview({
    Review? previousReview,
    required ProductID productId,
    required double rating,
    required String comment,
    required void Function() onSuccess,
  }) async {
    if (previousReview == null || rating != previousReview.rating || comment != previousReview.comment) {
      final review = Review(
        comment: comment,
        rating: rating,
        date: currentDateBuilder(),
      );
      state = const AsyncLoading();
      final newState = await AsyncValue.guard(() => reviewService.submitReview(productId, review));
      if (mounted) {
        /// only set the state if the controller is still mounted hasn't been disposed
        state = newState;
        if (!state.hasError) {
          onSuccess();
        }
      }
    } else {
      /// if the controller is not mounted, we should still call the onSuccess callback
      /// to avoid the UI from being stuck
      onSuccess();
    }
  }
}

final leaveReviewControllerProvider = StateNotifierProvider.autoDispose<LeaveReviewController, AsyncValue<void>>((ref) {
  final reviewService = ref.watch(reviewServiceProvider);
  return LeaveReviewController(
    reviewService: reviewService,
    ref: ref,
    currentDateBuilder: () => DateTime.now(),
  );
});
