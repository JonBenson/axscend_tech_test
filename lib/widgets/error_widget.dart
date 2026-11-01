import 'package:flutter/material.dart';

class ErrorMessageWidget extends StatelessWidget {
  const ErrorMessageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 200,
      child: Column(
        mainAxisAlignment: .center,
        children: [Icon(Icons.warning_outlined), Text('An error occurred')],
      ),
    );
  }
}
