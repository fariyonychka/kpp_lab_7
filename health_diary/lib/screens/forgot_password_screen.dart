import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/auth_container.dart';
import '../theme/app_colors.dart';
import '../repositories/auth_repository.dart';
import '../core/analytics_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _authRepo = AuthRepository();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    AnalyticsService.logScreenView('forgot_password');
  }

  Future<void> _sendReset() async {
    final loc = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await _authRepo.sendPasswordResetEmail(_emailCtrl.text.trim());
      if (mounted) {
        await AnalyticsService.logPasswordReset();
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(loc.emailSent)));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      body: AuthContainer(
        showBackButton: true,
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
                  child: Icon(Icons.lock, color: AppColors.card),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                loc.resetPassword,
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                loc.enterEmail,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
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
              const SizedBox(height: 24),

              _isLoading
                  ? const CircularProgressIndicator()
                  : CustomButton(
                      text: loc.sendInstructions,
                      onPressed: _sendReset,
                    ),

              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  loc.backToLogin,
                  style: const TextStyle(color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
