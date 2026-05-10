import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../core/utils/providers.dart';
import '../../../auth/presentation/providers/profile_provider.dart';
import '../../../tracking/data/repositories/tracking_repository_impl.dart';

/// Page paramètres principale.
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            title: Text('Paramètres', style: AppTextStyles.headlineMedium),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.horizontalPadding,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // --- Profil ---
                _SectionHeader(title: 'Profil'),
                profileAsync.when(
                  loading: () => const CircularProgressIndicator(),
                  error: (e, _) => Text('$e'),
                  data: (profile) => _ProfileTile(profile: profile),
                ),

                const SizedBox(height: 24),

                // --- IA ---
                const _SectionHeader(title: 'Intelligence Artificielle'),
                _SettingsTile(
                  icon: Icons.key_rounded,
                  label: 'Clés API',
                  subtitle: 'Configurer OpenAI, Gemini, Anthropic',
                  onTap: () => context.push(AppRoutes.apiKeys),
                ),

                const SizedBox(height: 24),

                // --- Apparence ---
                const _SectionHeader(title: 'Apparence'),
                _ThemeSwitcher(
                  currentMode: themeMode,
                  onChanged: (mode) {
                    ref.read(themeModeProvider.notifier).state = mode;
                    ref
                        .read(preferencesServiceProvider)
                        .setThemeMode(mode);
                  },
                ),

                const SizedBox(height: 24),

                // --- Données ---
                const _SectionHeader(title: 'Données'),
                _SettingsTile(
                  icon: Icons.delete_outline_rounded,
                  label: 'Effacer toutes les données',
                  subtitle: 'Supprimer définitivement l\'historique',
                  color: AppColors.error,
                  onTap: () => _confirmClearData(context, ref),
                ),

                const SizedBox(height: 24),

                // --- À propos ---
                const _SectionHeader(title: 'À propos'),
                _SettingsTile(
                  icon: Icons.code_rounded,
                  label: 'Code source',
                  subtitle: 'github.com/wicra/MesCalories',
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: Icons.privacy_tip_outlined,
                  label: 'Confidentialité',
                  subtitle: 'Vos données restent sur votre appareil',
                  onTap: () {},
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text(
                      'MesCalories v${AppConstants.appVersion} • Open Source',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.grey400,
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmClearData(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Effacer les données'),
        content: const Text(
          'Cette action est irréversible. Tout votre historique alimentaire sera supprimé.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ref
                  .read(trackingRepositoryProvider)
                  .clearAllData();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Données effacées.')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Effacer'),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Composants
// ---------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.labelSmall.copyWith(
          color: AppColors.grey400,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({required this.profile});
  final dynamic profile;

  @override
  Widget build(BuildContext context) {
    if (profile == null) {
      return _SettingsTile(
        icon: Icons.person_add_outlined,
        label: 'Configurer le profil',
        subtitle: 'Ajouter vos informations personnelles',
        onTap: () => context.go(AppRoutes.setup),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.accent, AppColors.accentLight],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    (profile.firstName as String).isNotEmpty
                        ? (profile.firstName as String)[0].toUpperCase()
                        : '?',
                    style: AppTextStyles.headlineLarge.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.firstName as String,
                      style: AppTextStyles.headlineMedium,
                    ),
                    Text(
                      '${profile.age} ans · ${(profile.weightKg as double).toStringAsFixed(0)} kg · ${(profile.heightCm as double).toStringAsFixed(0)} cm',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.grey500,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => context.go(AppRoutes.setup),
                child: const Text('Modifier'),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _GoalChip(
                label: 'Objectif',
                value: '${profile.dailyCalorieGoal} kcal',
              ),
              _GoalChip(
                label: 'Protéines',
                value: '${profile.proteinGoalG}g',
              ),
              _GoalChip(
                label: 'Glucides',
                value: '${profile.carbGoalG}g',
              ),
              _GoalChip(
                label: 'Graisses',
                value: '${profile.fatGoalG}g',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GoalChip extends StatelessWidget {
  const _GoalChip({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.headlineSmall.copyWith(
            color: AppColors.accent,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.grey500),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.subtitle,
    this.color,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? Theme.of(context).colorScheme.onSurface;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: c, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.labelLarge.copyWith(color: c),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.grey400,
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.grey400,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeSwitcher extends StatelessWidget {
  const _ThemeSwitcher({
    required this.currentMode,
    required this.onChanged,
  });
  final String currentMode;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const modes = [
      ('system', Icons.brightness_auto_rounded, 'Système'),
      ('light', Icons.light_mode_rounded, 'Clair'),
      ('dark', Icons.dark_mode_rounded, 'Sombre'),
    ];

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: modes.map((m) {
          final selected = currentMode == m.$1;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(m.$1),
              child: AnimatedContainer(
                duration: AppConstants.animationFast,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: selected
                      ? Theme.of(context).scaffoldBackgroundColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 8,
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  children: [
                    Icon(
                      m.$2,
                      color: selected
                          ? AppColors.accent
                          : AppColors.grey400,
                      size: 20,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      m.$3,
                      style: AppTextStyles.caption.copyWith(
                        color: selected
                            ? AppColors.accent
                            : AppColors.grey400,
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
