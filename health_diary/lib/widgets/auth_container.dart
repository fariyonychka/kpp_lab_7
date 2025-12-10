import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AuthContainer extends StatelessWidget {
  final Widget child;
  final bool showBackButton;

  const AuthContainer({
    super.key,
    required this.child,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.13, -0.26),
              end: Alignment(0.87, 1.26),
              colors: [Color(0xFFF5F7FA), Color(0xFFC3CFE2)],
            ),
          ),
        ),
        Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  shadowColor: AppColors.shadow,
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (showBackButton)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        child,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
