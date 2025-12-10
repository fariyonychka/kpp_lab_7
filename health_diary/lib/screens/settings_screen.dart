import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../core/analytics_service.dart';
import '../repositories/auth_repository.dart';
import '../repositories/health_repository.dart';
import '../widgets/custom_toast.dart';
import '../core/localization_provider.dart';
import '../models/user_profile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  String? _selectedGender;
  bool _isEditing = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _startEditing(UserProfile? profile) {
    if (profile != null) {
      _nameController.text = profile.name;
      _ageController.text = profile.age?.toString() ?? '';
      _selectedGender = profile.gender;
    }
    setState(() => _isEditing = true);
  }

  Future<void> _saveProfile(UserProfile? currentProfile) async {
    if (!_formKey.currentState!.validate()) return;
    if (currentProfile == null) return;

    setState(() => _isLoading = true);

    try {
      final updatedProfile = currentProfile.copyWith(
        name: _nameController.text.trim(),
        age: int.tryParse(_ageController.text.trim()),
        gender: _selectedGender,
      );

      await HealthRepository().updateUserProfile(updatedProfile);

      if (mounted) {
        CustomToast.showSuccess(
          context,
          AppLocalizations.of(context)!.recordSaved,
        );
        setState(() => _isEditing = false);
      }
    } catch (e) {
      if (mounted) {
        CustomToast.showError(context, e.toString());
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final localeProvider = context.read<LocalizationProvider>();
    final authRepo = AuthRepository();

    return StreamBuilder<UserProfile?>(
      stream: HealthRepository().getUserProfileStream(),
      builder: (context, snapshot) {
        final profile = snapshot.data;
        final email = FirebaseAuth.instance.currentUser?.email ?? '—';

        // Initialize controllers if not editing and data loaded
        if (!_isEditing && profile != null && _nameController.text.isEmpty) {
          _nameController.text = profile.name;
          _ageController.text = profile.age?.toString() ?? '';
          _selectedGender = profile.gender;
        }

        return CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            loc.settings,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (!_isEditing)
                            TextButton.icon(
                              onPressed: () => _startEditing(profile),
                              icon: const Icon(Icons.edit),
                              label: Text(loc.edit),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      _buildLanguageRow(context, loc, localeProvider),

                      const Divider(height: 40),
                      Text(
                        loc.myData,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),

                      if (_isEditing) ...[
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: loc.name,
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? loc.fieldRequired
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _ageController,
                          decoration: InputDecoration(
                            labelText: loc.age,
                            border: const OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedGender,
                          decoration: InputDecoration(
                            labelText: loc.gender,
                            border: const OutlineInputBorder(),
                          ),
                          items: [
                            DropdownMenuItem(
                              value: 'Чоловіча',
                              child: Text(loc.male),
                            ),
                            DropdownMenuItem(
                              value: 'Жіноча',
                              child: Text(loc.femaleGender),
                            ),
                            DropdownMenuItem(
                              value: 'Інше',
                              child: Text(loc.other),
                            ),
                          ],
                          onChanged: (value) =>
                              setState(() => _selectedGender = value),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () =>
                                    setState(() => _isEditing = false),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                ),
                                child: Text(loc.cancel),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _isLoading
                                    ? null
                                    : () => _saveProfile(profile),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
                                        loc.save,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        _buildInfoRow('${loc.name}:', profile?.name ?? '—'),
                        _buildInfoRow(
                          '${loc.age}:',
                          profile?.age != null
                              ? '${profile!.age} ${loc.yearsOld}'
                              : '—',
                        ),
                        _buildInfoRow('${loc.gender}:', profile?.gender ?? '—'),
                        _buildInfoRow('${loc.email}:', email),
                      ],

                      const Spacer(),
                      if (!_isEditing) ...[
                        const SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              AnalyticsService.logEvent('logout_pressed');
                              await authRepo.signOut();
                              if (context.mounted) {
                                CustomToast.showInfo(
                                  context,
                                  loc.logoutSuccess,
                                );
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  '/login',
                                  (route) => false,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade600,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              loc.logout,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLanguageRow(
    BuildContext context,
    AppLocalizations loc,
    LocalizationProvider provider,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(loc.language, style: const TextStyle(fontSize: 16)),
          DropdownButton<String>(
            value: provider.locale.languageCode,
            items: [
              DropdownMenuItem(value: 'en', child: Text(loc.english)),
              DropdownMenuItem(value: 'uk', child: Text(loc.ukrainian)),
            ],
            onChanged: (value) {
              if (value != null) {
                provider.setLocale(value);
                AnalyticsService.logEvent('language_changed');
              }
            },
            underline: const SizedBox(),
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
