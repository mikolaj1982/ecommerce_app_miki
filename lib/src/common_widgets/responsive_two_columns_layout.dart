import 'package:flutter/material.dart';

class ResponsiveTwoColumnLayout extends StatelessWidget {
  final Widget startWidget;
  final Widget endWidget;
  final double spacing;
  final int startFlex;
  final int endFlex;
  final double breakpoint;
  final MainAxisAlignment rowMainAxisAlignment;
  final CrossAxisAlignment rowCrossAxisAlignment;
  final MainAxisAlignment columnMainAxisAlignment;
  final CrossAxisAlignment columnCrossAxisAlignment;

  const ResponsiveTwoColumnLayout({
    super.key,
    required this.startWidget,
    required this.endWidget,
    this.startFlex = 1,
    this.endFlex = 1,
    this.breakpoint = 900,
    required this.spacing,
    this.rowMainAxisAlignment = MainAxisAlignment.start,
    this.rowCrossAxisAlignment = CrossAxisAlignment.start,
    this.columnMainAxisAlignment = MainAxisAlignment.start,
    this.columnCrossAxisAlignment = CrossAxisAlignment.stretch,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= breakpoint) {
          return Row(
            mainAxisAlignment: rowMainAxisAlignment,
            crossAxisAlignment: rowCrossAxisAlignment,
            children: [
              Flexible(flex: startFlex, child: startWidget),
              SizedBox(width: spacing),
              Flexible(flex: endFlex, child: endWidget),
            ],
          );
        } else {
          return Column(
            mainAxisAlignment: columnMainAxisAlignment,
            crossAxisAlignment: columnCrossAxisAlignment,
            children: [
              startWidget,
              SizedBox(height: spacing),
              endWidget,
            ],
          );
        }
      },
    );
  }
}
