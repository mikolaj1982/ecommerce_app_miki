import 'package:flutter/material.dart';

class DecoratedBoxWithShadow extends StatelessWidget {
  final Widget child;

  const DecoratedBoxWithShadow({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
        decoration: const BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0),
            blurRadius: 5.0,
          ),
        ]),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: child,
        ));
  }
}
