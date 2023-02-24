import 'package:ecommerce_app_miki/src/common_widgets/custom_text_button.dart';
import 'package:ecommerce_app_miki/src/common_widgets/responsive_two_columns_layout.dart';
import 'package:ecommerce_app_miki/src/common_widgets/typedefs.dart';
import 'package:ecommerce_app_miki/src/features/orders/user_orders_provider.dart';
import 'package:ecommerce_app_miki/src/features/reviews/review_service.dart';
import 'package:ecommerce_app_miki/src/models/order_model.dart';
import 'package:ecommerce_app_miki/src/models/review_model.dart';
import 'package:ecommerce_app_miki/src/routing/app_router.dart';
import 'package:ecommerce_app_miki/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LeaveReviewAction extends ConsumerWidget {
  final ProductID productId;

  const LeaveReviewAction({
    Key? key,
    required this.productId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Order>? orders = ref.watch(userOrdersByProductProvider(productId)).value;
    if (orders != null && orders.isNotEmpty) {
      // debugPrint('got orders for current user for product $productId: $orders');
      final dateFormatted = ref.watch(dateFormatterProvider).format(orders.first.orderDate);
      final Review? reviewValue = ref.watch(userReviewProvider(productId)).value;
      return Column(
        children: [
          const Divider(),
          const SizedBox(height: 8),
          ResponsiveTwoColumnLayout(
            spacing: 16,
            breakpoint: 300,
            startFlex: 3,
            endFlex: 2,
            rowMainAxisAlignment: MainAxisAlignment.spaceBetween,
            rowCrossAxisAlignment: CrossAxisAlignment.center,
            columnCrossAxisAlignment: CrossAxisAlignment.center,
            startWidget: Text('Purchased on $dateFormatted'),
            endWidget: CustomTextButton(
              text: (reviewValue != null) ? 'Update a review' : 'Leave a review',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.blue[700]),
              onPressed: () => context.goNamed(
                AppRoute.review.name,
                params: {'id': productId},
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
