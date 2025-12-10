import 'package:flutter/material.dart';

class SidebarItem extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const SidebarItem({
    super.key,
    required this.title,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        color: isActive ? const Color(0x19FFFFFF) : Colors.transparent,
        child: Row(
          children: [
            const SizedBox(width: 25),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
