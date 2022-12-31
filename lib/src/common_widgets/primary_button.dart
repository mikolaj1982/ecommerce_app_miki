import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;
  final String text;

  const PrimaryButton({
    Key? key,
    required this.text,
    this.isLoading = false,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: isLoading
          ? const CircularProgressIndicator()
          : Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.white),
            ),
    );
  }
}
