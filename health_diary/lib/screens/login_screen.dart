import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/auth_container.dart';
import '../repositories/auth_repository.dart';
import '../core/analytics_service.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_toast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _authRepo = AuthRepository();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    AnalyticsService.logScreenView('login');
  }

  Future<void> _login() async {
    final loc = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final user = await _authRepo.signIn(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text,
      );
      if (mounted && user != null) {
        await AnalyticsService.logLogin();
        await AnalyticsService.setUserId(user.uid);
        if (!mounted) return;
        CustomToast.showSuccess(context, loc.loginSuccess);
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      if (mounted) CustomToast.showError(context, 'Помилка входу: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      body: AuthContainer(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: const Center(
                  child: Text('❤️', style: TextStyle(fontSize: 32)),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                loc.appTitle,
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 30),

              CustomTextField(
                icon: Icons.mail,
                label: loc.email,
                hint: 'your@email.com',
                controller: _emailCtrl,
                validator: (v) {
                  if (v == null || v.isEmpty) return loc.requiredField;
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(v)) {
                    return loc.emailInvalid;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                icon: Icons.password,
                label: loc.password,
                hint: '••••••••',
                controller: _passCtrl,
                obscureText: true,
                validator: (v) =>
                    v == null || v.isEmpty ? loc.requiredField : null,
              ),
              const SizedBox(height: 24),

              _isLoading
                  ? const CircularProgressIndicator()
                  : CustomButton(text: loc.login, onPressed: _login),

              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/forgot'),
                child: Text(
                  loc.forgotPassword,
                  style: const TextStyle(color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 8),
              Text.rich(
                TextSpan(
                  text: '${loc.noAccount}? ',
                  children: [
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/register'),
                        child: Text(
                          loc.register,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
