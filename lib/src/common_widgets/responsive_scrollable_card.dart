import 'package:ecommerce_app_miki/src/common_widgets/responsive_center.dart';
import 'package:flutter/material.dart';

class ResponsiveScrollableCard extends StatelessWidget {
  final Widget child;

  const ResponsiveScrollableCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ResponsiveCenter(
        maxContentWidth: 600,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
