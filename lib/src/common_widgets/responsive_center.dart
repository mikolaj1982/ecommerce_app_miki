import 'package:flutter/material.dart';

class ResponsiveCenter extends StatelessWidget {
  final double maxContentWidth;
  final EdgeInsetsGeometry padding;
  final Widget child;

  const ResponsiveCenter({
    super.key,
    this.maxContentWidth = 900,
    this.padding = EdgeInsets.zero,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: maxContentWidth,
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}

/// Sliver
/// a sliver is a portion of a custom scrollable area
/// Slivers should always be placed inside a CustomScrollView
/// Flutter provides a number of slivers
/// we do not use standard widgets as slivers
class ResponsiveSliverCenter extends StatelessWidget {
  final double maxContentWidth;
  final EdgeInsetsGeometry padding;
  final Widget child;

  const ResponsiveSliverCenter({
    super.key,
    this.maxContentWidth = 900,
    this.padding = EdgeInsets.zero,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: ResponsiveCenter(
        maxContentWidth: maxContentWidth,
        padding: padding,
        child: child,
      ),
    );
  }
}
