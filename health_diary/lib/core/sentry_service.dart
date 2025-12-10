import 'package:sentry_flutter/sentry_flutter.dart';

class SentryService {
  static Future<void> initialize() async {
    await SentryFlutter.init((options) {
      options.dsn =
          'https://af31dbdd5260bf09122fa1afcd932c53@o4510272936869888.ingest.de.sentry.io/4510272940081232';
      options.tracesSampleRate = 1.0;
      options.attachStacktrace = true;
    });
  }

  static Future<void> setUserId(String id) async {
    await Sentry.configureScope((scope) {
      scope.setUser(SentryUser(id: id));
    });
  }

  static void testCrash() {
    throw Exception('Тестова помилка Sentry.io!');
  }

  static Future<void> captureMessage(String message) async {
    await Sentry.captureMessage(message);
  }
}
