import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/auth_check.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'core/analytics_service.dart';
import 'core/sentry_service.dart';
import 'firebase_options.dart';
import 'theme/app_colors.dart';
import 'l10n/app_localizations.dart';
import 'core/localization_provider.dart';
import 'providers/records_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SentryService.initialize();

  runApp(const HealthDiaryApp());
}

class HealthDiaryApp extends StatelessWidget {
  const HealthDiaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocalizationProvider()),
        ChangeNotifierProvider(create: (_) => RecordsProvider()),
      ],
      child: Consumer<LocalizationProvider>(
        builder: (context, localeProvider, child) {
          return MaterialApp(
            title: 'Щоденник здоров’я',
            debugShowCheckedModeBanner: false,
            locale: localeProvider.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('uk'), Locale('en')],
            theme: ThemeData(
              fontFamily: 'Inter',
              useMaterial3: true,
              scaffoldBackgroundColor: AppColors.background,
              cardColor: Colors.white,
            ),
            navigatorObservers: [
              AnalyticsService.observer,
              SentryNavigatorObserver(),
            ],
            home: const AuthCheck(),
            routes: {
              '/login': (_) => const LoginScreen(),
              '/register': (_) => const RegisterScreen(),
              '/forgot': (_) => const ForgotPasswordScreen(),
              '/home': (_) => const HomeScreen(),
              '/settings': (_) => const SettingsScreen(),
            },
          );
        },
      ),
    );
  }
}
