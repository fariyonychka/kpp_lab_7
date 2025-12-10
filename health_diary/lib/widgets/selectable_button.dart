import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SelectableButton extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;
  final double height;
  final EdgeInsetsGeometry? padding;

  const SelectableButton({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
    this.height = 97,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: height,
          padding: padding ?? const EdgeInsets.all(17),
          decoration: ShapeDecoration(
            color: selected ? const Color(0xFFF0F8F0) : Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 2,
                color: selected ? AppColors.primary : AppColors.border,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
