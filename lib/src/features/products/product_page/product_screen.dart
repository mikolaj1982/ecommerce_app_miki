import 'package:ecommerce_app_miki/src/common_widgets/async_value_widget.dart';
import 'package:ecommerce_app_miki/src/common_widgets/responsive_center.dart';
import 'package:ecommerce_app_miki/src/common_widgets/responsive_two_columns_layout.dart';
import 'package:ecommerce_app_miki/src/common_widgets/typedefs.dart';
import 'package:ecommerce_app_miki/src/features/home_app_bar/home_app_bar.dart';
import 'package:ecommerce_app_miki/src/features/not_found/empty_placeholder_widget.dart';
import 'package:ecommerce_app_miki/src/features/products/product_page/product_reviews/products_reviews_list.dart';
import 'package:ecommerce_app_miki/src/features/products/providers/products_provider.dart';
import 'package:ecommerce_app_miki/src/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'add_to_cart/add_to_cart_widget.dart';
import 'leave_review_action.dart';

class ProductScreen extends StatelessWidget {
  final ProductID productId;

  const ProductScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: Consumer(
        builder: (context, ref, child) {
          final AsyncValue<Product?> productStream = ref.watch(productProvider(productId));
          return AsyncValueWidget<Product?>(
            value: productStream,
            data: (product) {
              return product == null
                  ? const EmptyPlaceholderWidget(
                      message: 'Product not found',
                    )
                  : CustomScrollView(slivers: [
                      ResponsiveSliverCenter(
                        child: ProductDetails(
                          product: product,
                        ),
                      ),
                      const ProductReviewsList(),
                    ]);
            },
          );
        },
      ),
    );
  }
}

class ProductDetails extends StatelessWidget {
  final Product product;

  const ProductDetails({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final priceFormatted = NumberFormat.simpleCurrency().format(product.price);
    return ResponsiveTwoColumnLayout(
      startWidget: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Image.asset(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
      endWidget: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                product.title,
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 8),
              Text(
                product.description,
                style: Theme.of(context).textTheme.bodyText2,
              ),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                priceFormatted,
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 8),
              LeaveReviewAction(productId: product.id),
              const Divider(),
              const SizedBox(height: 8),
              AddToCartWidget(product: product),
            ],
          ),
        ),
      ),
      spacing: 16.0,
    );
  }
}
