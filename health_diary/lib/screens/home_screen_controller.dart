import 'package:flutter/material.dart';

class HomeScreenController {
  VoidCallback? _onNavigateToHome;

  void setNavigateToHome(VoidCallback callback) {
    _onNavigateToHome = callback;
  }

  void goHome() {
    _onNavigateToHome?.call();
  }
}
