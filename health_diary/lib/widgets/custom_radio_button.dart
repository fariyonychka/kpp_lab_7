import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class CustomRadioButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const CustomRadioButton({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? AppColors.primary : AppColors.placeholder,
                width: 2,
              ),
              color: selected ? AppColors.primary : Colors.transparent,
            ),
            child: selected
                ? const Icon(Icons.circle, size: 10, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
