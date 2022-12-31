import 'package:ecommerce_app_miki/src/common_widgets/custom_text_button.dart';
import 'package:ecommerce_app_miki/src/common_widgets/responsive_two_columns_layout.dart';
import 'package:ecommerce_app_miki/src/common_widgets/typedefs.dart';
import 'package:ecommerce_app_miki/src/models/purchase_model.dart';
import 'package:ecommerce_app_miki/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class LeaveReviewAction extends StatelessWidget {
  final ProductID productId;

  const LeaveReviewAction({
    Key? key,
    required this.productId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Purchase purchase = Purchase(
      orderId: 'abc',
      orderDate: DateTime.now(),
    );
    if (purchase != null) {
      final dateFormatted = DateFormat.yMMMd().format(purchase.orderDate);
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
              text: 'Leave a review',
              style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.blue[700]),
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
      return const SizedBox();
    }
  }
}
