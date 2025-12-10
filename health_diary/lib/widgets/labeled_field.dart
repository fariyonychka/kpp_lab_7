import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class LabeledField extends StatelessWidget {
  final String? label;
  final Widget field;

  const LabeledField({super.key, this.label, required this.field});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Text(
            label!,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        const SizedBox(height: 8),
        field,
      ],
    );
  }
}
