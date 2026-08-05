import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:snake_app/app/routes.dart';
import 'package:snake_app/app/providers.dart';
import 'package:snake_app/core/l10n/l10n_extensions.dart';
import 'package:snake_app/core/theme/app_colors.dart';
import 'package:snake_app/core/utils/navigation.dart';
import 'package:snake_app/core/utils/profile_validators.dart';
import 'package:snake_app/shared/widgets/app_chrome.dart';
import 'package:snake_app/shared/widgets/app_text_field.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _username;
  late final TextEditingController _fullName;
  late final TextEditingController _email;
  late final TextEditingController _phone;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileControllerProvider).profile;
    _username = TextEditingController(text: profile?.username ?? '');
    _fullName = TextEditingController(text: profile?.fullName ?? '');
    _email = TextEditingController(text: profile?.email ?? '');
    _phone = TextEditingController(text: profile?.phone ?? '');
  }

  @override
  void dispose() {
    _username.dispose();
    _fullName.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final saveResult =
          await ref.read(profileControllerProvider.notifier).saveProfile(
                username: _username.text.trim(),
                fullName: _fullName.text.trim(),
                email: ProfileValidators.normalizeEmail(_email.text),
                phone: ProfileValidators.normalizePhone(_phone.text),
              );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            saveResult.didSavePendingScore
                ? context.l10n.profileSavedWithScore
                : context.l10n.profileSaved,
          ),
        ),
      );
      context.go(AppRoutes.home);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String? _usernameError(AppLocalizations l10n, String? value) {
    return switch (ProfileValidators.username(value)) {
      'required' => l10n.usernameRequiredError,
      'tooShort' => l10n.usernameTooShort,
      'tooLong' => l10n.usernameTooLong,
      'invalid' => l10n.usernameInvalid,
      _ => null,
    };
  }

  String? _fullNameError(AppLocalizations l10n, String? value) {
    return switch (ProfileValidators.fullName(value)) {
      'required' => l10n.fullNameRequiredError,
      'tooShort' => l10n.fullNameTooShort,
      'tooLong' => l10n.fullNameTooLong,
      _ => null,
    };
  }

  String? _emailError(AppLocalizations l10n, String? value) {
    return switch (ProfileValidators.email(value)) {
      'invalid' => l10n.emailInvalid,
      _ => null,
    };
  }

  String? _phoneError(AppLocalizations l10n, String? value) {
    return switch (ProfileValidators.phone(value)) {
      'invalid' => l10n.phoneInvalid,
      _ => null,
    };
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileControllerProvider);
    final progress = state.progress;
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(state.hasProfile ? l10n.profile : l10n.createProfile),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => popOrGoHome(context),
        ),
      ),
      body: AtmosphereBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          children: [
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.brandPrimary.withValues(alpha: 0.2),
                child: Text(
                  state.profile?.initial ?? '?',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.brandPrimaryLight,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (progress != null) ...[
              SurfaceCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _Stat(
                      label: l10n.best,
                      value: '${progress.bestOverallScore}',
                    ),
                    _Stat(
                      label: l10n.level,
                      value: '${progress.highestLevelUnlocked}',
                    ),
                    _Stat(
                      label: l10n.games,
                      value: '${progress.gamesPlayed}',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            SurfaceCard(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    AppTextField(
                      controller: _username,
                      label: l10n.usernameRequired,
                      hintText: l10n.usernameHint,
                      required: true,
                      textInputAction: TextInputAction.next,
                      prefixIcon: const Icon(Icons.person_outline_rounded),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z0-9_]'),
                        ),
                        LengthLimitingTextInputFormatter(
                          ProfileValidators.maxUsernameLength,
                        ),
                      ],
                      validator: (value) => _usernameError(l10n, value),
                    ),
                    const SizedBox(height: 14),
                    AppTextField(
                      controller: _fullName,
                      label: l10n.fullNameRequired,
                      hintText: l10n.fullNameHint,
                      required: true,
                      textInputAction: TextInputAction.next,
                      prefixIcon: const Icon(Icons.badge_outlined),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(
                          ProfileValidators.maxFullNameLength,
                        ),
                      ],
                      validator: (value) => _fullNameError(l10n, value),
                    ),
                    const SizedBox(height: 14),
                    AppTextField(
                      controller: _email,
                      label: l10n.emailOptional,
                      hintText: l10n.emailHint,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      prefixIcon: const Icon(Icons.mail_outline_rounded),
                      validator: (value) => _emailError(l10n, value),
                    ),
                    const SizedBox(height: 14),
                    AppTextField(
                      controller: _phone,
                      label: l10n.phoneOptional,
                      hintText: l10n.phoneHint,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      prefixIcon: const Icon(Icons.phone_outlined),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[\d+\s\-().]'),
                        ),
                        LengthLimitingTextInputFormatter(20),
                      ],
                      validator: (value) => _phoneError(l10n, value),
                      onSubmitted: (_) => _save(),
                    ),
                    const SizedBox(height: 20),
                    PrimaryCta(
                      label: _saving ? l10n.saving : l10n.save,
                      onPressed: _saving ? null : _save,
                      isLoading: _saving,
                      expanded: true,
                      icon: Icons.check_rounded,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.profileHelp,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.6),
              ),
        ),
      ],
    );
  }
}
