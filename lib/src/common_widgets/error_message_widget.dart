import 'package:flutter/material.dart';

class ErrorMessageWidget extends StatelessWidget {
  final String errorMsg;

  const ErrorMessageWidget(this.errorMsg, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      errorMsg,
      style: Theme.of(context).textTheme.headline6!.copyWith(
            color: Colors.red,
          ),
    );
  }
}
