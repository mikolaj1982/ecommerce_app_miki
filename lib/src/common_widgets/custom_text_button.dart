import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final VoidCallback? onPressed;

  const CustomTextButton({
    super.key,
    required this.text,
    this.style,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: style,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
