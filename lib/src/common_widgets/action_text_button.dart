import 'package:flutter/material.dart';

class ActionTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const ActionTextButton({
    super.key,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: Theme.of(context).textTheme.headline6!.copyWith(
                color: Colors.white,
              ),
        ),
      ),
    );
  }
}
