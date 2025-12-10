import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_radio_button.dart';
import '../widgets/auth_container.dart';
import '../repositories/auth_repository.dart';
import '../core/analytics_service.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_toast.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  String _gender = 'male';
  final _authRepo = AuthRepository();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    AnalyticsService.logScreenView('register');
  }

  Future<void> _register() async {
    final loc = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await _authRepo.signUp(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text,
        name: _nameCtrl.text.trim(),
        age: int.tryParse(_ageCtrl.text) ?? 0,
        gender: _gender,
      );
      if (mounted) {
        await AnalyticsService.logSignUp();
        if (!mounted) return;
        CustomToast.showSuccess(context, loc.registerSuccess);
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      if (mounted) CustomToast.showError(context, 'Помилка реєстрації: $e');
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
                  child: Icon(Icons.person_add, color: AppColors.card),
                ),
              ),
              Text(
                loc.createAccount,
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(loc.joinHealthyLife, style: const TextStyle(fontSize: 15)),
              const SizedBox(height: 30),

              CustomTextField(
                icon: Icons.person,
                label: loc.name,
                hint: loc.nameHint,
                controller: _nameCtrl,
                validator: (v) =>
                    v?.trim().isEmpty == true ? loc.requiredField : null,
              ),
              const SizedBox(height: 16),
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
                validator: (v) {
                  if (v == null || v.isEmpty) return loc.requiredField;
                  if (v.length < 6) return loc.passwordMin6;
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                icon: Icons.access_time,
                label: loc.age,
                hint: '25',
                controller: _ageCtrl,
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return loc.requiredField;
                  final age = int.tryParse(v);
                  if (age == null || age < 1 || age > 135) {
                    return loc.ageInvalid;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loc.gender,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      children: [loc.male, loc.female, loc.other].map((g) {
                        return CustomRadioButton(
                          label: g,
                          selected:
                              _gender ==
                              (g == loc.male
                                  ? 'male'
                                  : g == loc.female
                                  ? 'female'
                                  : 'other'),
                          onTap: () => setState(
                            () => _gender = g == loc.male
                                ? 'male'
                                : g == loc.female
                                ? 'female'
                                : 'other',
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              _isLoading
                  ? const CircularProgressIndicator()
                  : CustomButton(
                      text: loc.registerButton,
                      onPressed: _register,
                    ),

              const SizedBox(height: 16),
              Text.rich(
                TextSpan(
                  text: '${loc.haveAccount} ',
                  children: [
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          loc.login,
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
