import 'package:axscend_tech_test/config/app_theme.dart';
import 'package:flutter/material.dart';

class TextWithLabel extends StatelessWidget {
  const TextWithLabel({super.key, required this.label, required this.text});

  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(color: AppColors.label),
        ),
        Text(text, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}
