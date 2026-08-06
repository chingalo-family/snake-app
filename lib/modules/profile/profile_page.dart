import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:snake_app/app/routes.dart';
import 'package:snake_app/app/providers.dart';
import 'package:snake_app/core/constants/profile_avatars.dart';
import 'package:snake_app/core/l10n/l10n_extensions.dart';
import 'package:snake_app/core/theme/app_colors.dart';
import 'package:snake_app/core/utils/page_insets.dart';
import 'package:snake_app/core/utils/profile_validators.dart';
import 'package:snake_app/modules/profile/components/profile_avatar_picker.dart';
import 'package:snake_app/modules/profile/components/profile_stat.dart';
import 'package:snake_app/shared/widgets/app_chrome.dart';
import 'package:snake_app/shared/widgets/app_text_field.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _phone;
  String _selectedAvatarId = ProfileAvatarCatalog.defaultAvatarId;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileControllerProvider).profile;
    _name = TextEditingController(text: profile?.name ?? '');
    _email = TextEditingController(text: profile?.email ?? '');
    _phone = TextEditingController(text: profile?.phone ?? '');
    _selectedAvatarId = profile?.avatarId ?? ProfileAvatarCatalog.defaultAvatarId;
  }

  @override
  void dispose() {
    _name.dispose();
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
                name: _name.text.trim(),
                avatarId: _selectedAvatarId,
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

  String? _nameError(AppLocalizations l10n, String? value) {
    return switch (ProfileValidators.name(value)) {
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
      appBar: SnakePageAppBar(
        showBackButton: true,
        showHomeButton: true,
        showMoreButton: true,
        title: Text(state.hasProfile ? l10n.profile : l10n.createProfile),
        showProfileOptionInMenu: false,
      ),
      body: AtmosphereBackground(
        child: ListView(
          padding: pageScrollPadding(context),
          children: [
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.brandPrimary.withValues(alpha: 0.2),
                child: Text(
                  state.profile?.avatarEmoji ??
                      ProfileAvatarCatalog.byId(_selectedAvatarId).emoji,
                  style: theme.textTheme.headlineMedium,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ProfileAvatarPicker(
              selectedAvatarId: _selectedAvatarId,
              onAvatarSelected: (avatarId) {
                setState(() => _selectedAvatarId = avatarId);
              },
            ),
            const SizedBox(height: 16),
            if (progress != null) ...[
              SurfaceCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ProfileStat(
                      label: l10n.best,
                      value: '${progress.bestOverallScore}',
                    ),
                    ProfileStat(
                      label: l10n.level,
                      value: '${progress.highestLevelUnlocked}',
                    ),
                    ProfileStat(
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
                      controller: _name,
                      label: l10n.fullNameRequired,
                      hintText: l10n.fullNameHint,
                      required: true,
                      textInputAction: TextInputAction.next,
                      prefixIcon: const Icon(Icons.badge_outlined),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(
                          ProfileValidators.maxNameLength,
                        ),
                      ],
                      validator: (value) => _nameError(l10n, value),
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
