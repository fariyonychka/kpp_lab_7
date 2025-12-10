import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  static final observer = FirebaseAnalyticsObserver(analytics: _analytics);

  static Future<void> logScreenView(String name) async {
    await _analytics.logScreenView(screenName: name, screenClass: name);
  }

  static Future<void> logLogin() async {
    await _analytics.logLogin(loginMethod: 'email');
  }

  static Future<void> logSignUp() async {
    await _analytics.logSignUp(signUpMethod: 'email');
  }

  static Future<void> logPasswordReset() async {
    await _analytics.logEvent(name: 'password_reset_requested');
  }

  static Future<void> logEvent(String name) async {
    await _analytics.logEvent(name: name);
  }

  static Future<void> setUserId(String id) async {
    await _analytics.setUserId(id: id);
  }
}
