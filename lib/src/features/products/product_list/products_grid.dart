import 'dart:math';

import 'package:ecommerce_app_miki/src/common_widgets/async_value_widget.dart';
import 'package:ecommerce_app_miki/src/features/products/product_list/products_card.dart';
import 'package:ecommerce_app_miki/src/features/products/product_list/products_search_state_provider.dart';
import 'package:ecommerce_app_miki/src/models/product_model.dart';
import 'package:ecommerce_app_miki/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProductsGrid extends ConsumerWidget {
  const ProductsGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // whenever we watch the StreamProvider the widget will rebuild every time the stream emits a new value
    final AsyncValue<List<Product>> productsListValue = ref.watch(productsSearchResultsProvider);

    return AsyncValueWidget<List<Product>>(
      value: productsListValue,
      data: (products) {
        return products.isEmpty
            ? Center(
                child: Text(
                'No products found',
                style: Theme.of(context).textTheme.headlineMedium,
              ))
            : ProductsLayoutGrid(
                itemCount: products.length,
                itemBuilder: (_, index) {
                  final product = products[index];
                  return ProductCard(
                    index: index,
                    product: product,
                    onPressed: () => context.goNamed(
                      AppRoute.product.name,
                      params: {'id': product.id},
                    ),
                  );
                },
              );
      },
    );
  }
}

class ProductsLayoutGrid extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;

  const ProductsLayoutGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final crossAxisCount = max(1, width ~/ 250);
          final columnSizes = List.generate(crossAxisCount, (_) => 1.fr);
          final numRows = (itemCount / crossAxisCount).ceil();
          final rowSizes = List.generate(numRows, (_) => auto);

          // debugPrint('width: $width');
          // debugPrint('crossAxisCount: $crossAxisCount');
          // debugPrint('columnSizes: $columnSizes');
          // debugPrint('numRows: $numRows');
          // debugPrint('rowSizes: $rowSizes');

          return LayoutGrid(
            rowGap: 24.0,
            columnGap: 24.0,
            columnSizes: columnSizes,
            rowSizes: rowSizes,
            children: [for (var i = 0; i < itemCount; i++) itemBuilder(context, i)],
          );
        },
      ),
    );
  }
}
