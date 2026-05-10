import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/navigation/app_router.dart';
import '../../presentation/providers/profile_provider.dart';

/// Page de configuration du profil utilisateur.
/// Collecte les données personnelles pour calculer l'objectif calorique.
class ProfileSetupPage extends ConsumerStatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  ConsumerState<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends ConsumerState<ProfileSetupPage> {
  final _pageController = PageController();
  final _firstNameController = TextEditingController();
  int _currentStep = 0;
  final int _totalSteps = 5;

  @override
  void dispose() {
    _pageController.dispose();
    _firstNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileSetupNotifierProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildProgressBar(state),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _NameStep(controller: _firstNameController),
                  _SexStep(),
                  _MeasurementsStep(),
                  _ActivityStep(),
                  _GoalStep(),
                ],
              ),
            ),
            _buildButtons(state),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Row(
        children: [
          if (_currentStep > 0)
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: _goBack,
            ),
          const Spacer(),
          Text(
            'Étape ${_currentStep + 1}/$_totalSteps',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.grey500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(ProfileSetupState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: LinearProgressIndicator(
          value: (_currentStep + 1) / _totalSteps,
          backgroundColor: AppColors.grey200,
          valueColor:
              const AlwaysStoppedAnimation<Color>(AppColors.accent),
          minHeight: 4,
        ),
      ),
    );
  }

  Widget _buildButtons(ProfileSetupState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: Column(
        children: [
          if (state.error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                state.error!,
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.error),
                textAlign: TextAlign.center,
              ),
            ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: state.isLoading ? null : _onNext,
              child: state.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.white,
                      ),
                    )
                  : Text(
                      _currentStep == _totalSteps - 1
                          ? 'Calculer mon objectif'
                          : 'Continuer',
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _goBack() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: AppConstants.animationMedium,
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _onNext() async {
    final notifier = ref.read(profileSetupNotifierProvider.notifier);

    if (_currentStep == 0) {
      notifier.setFirstName(_firstNameController.text);
    }

    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: AppConstants.animationMedium,
        curve: Curves.easeInOut,
      );
    } else {
      final success = await notifier.saveProfile();
      if (success && mounted) {
        context.go(AppRoutes.dashboard);
      }
    }
  }
}

// ---------------------------------------------------------------------------
// Étapes
// ---------------------------------------------------------------------------

class _NameStep extends StatelessWidget {
  const _NameStep({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return _StepContainer(
      emoji: '👋',
      title: 'Bonjour !\nQuel est votre prénom ?',
      child: TextField(
        controller: controller,
        autofocus: true,
        textCapitalization: TextCapitalization.words,
        style: AppTextStyles.headlineMedium,
        decoration: const InputDecoration(
          hintText: 'Votre prénom...',
        ),
      ),
    );
  }
}

class _SexStep extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileSetupNotifierProvider);
    final notifier = ref.read(profileSetupNotifierProvider.notifier);

    return _StepContainer(
      emoji: '🧬',
      title: 'Sexe biologique',
      subtitle: 'Utilisé pour calculer votre métabolisme de base.',
      child: Row(
        children: BiologicalSex.values.map((sex) {
          final selected = state.biologicalSex == sex;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: GestureDetector(
                onTap: () => notifier.setSex(sex),
                child: AnimatedContainer(
                  duration: AppConstants.animationFast,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.accent.withValues(alpha: 0.12)
                        : Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: selected ? AppColors.accent : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        sex == BiologicalSex.male ? '♂️' : '♀️',
                        style: const TextStyle(fontSize: 32),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        sex.label,
                        style: AppTextStyles.labelMedium.copyWith(
                          color: selected ? AppColors.accent : null,
                          fontWeight: selected
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _MeasurementsStep extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileSetupNotifierProvider);
    final notifier = ref.read(profileSetupNotifierProvider.notifier);

    return _StepContainer(
      emoji: '📏',
      title: 'Vos mesures',
      child: Column(
        children: [
          _SliderField(
            label: 'Âge',
            value: state.age.toDouble(),
            min: 15,
            max: 85,
            divisions: 70,
            unit: 'ans',
            onChanged: (v) => notifier.setAge(v.round()),
          ),
          const SizedBox(height: 24),
          _SliderField(
            label: 'Poids',
            value: state.weightKg,
            min: 40,
            max: 200,
            divisions: 160,
            unit: 'kg',
            decimals: 1,
            onChanged: (v) => notifier.setWeight(
              double.parse(v.toStringAsFixed(1)),
            ),
          ),
          const SizedBox(height: 24),
          _SliderField(
            label: 'Taille',
            value: state.heightCm,
            min: 140,
            max: 220,
            divisions: 80,
            unit: 'cm',
            onChanged: (v) => notifier.setHeight(v.roundToDouble()),
          ),
        ],
      ),
    );
  }
}

class _ActivityStep extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileSetupNotifierProvider);
    final notifier = ref.read(profileSetupNotifierProvider.notifier);

    return _StepContainer(
      emoji: '🏃',
      title: 'Niveau d\'activité',
      child: Column(
        children: ActivityLevel.values.map((level) {
          final selected = state.activityLevel == level;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: () => notifier.setActivity(level),
              child: AnimatedContainer(
                duration: AppConstants.animationFast,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.accent.withValues(alpha: 0.1)
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: selected ? AppColors.accent : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            level.label,
                            style: AppTextStyles.headlineSmall.copyWith(
                              color: selected ? AppColors.accent : null,
                            ),
                          ),
                          Text(
                            level.description,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.grey500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (selected)
                      const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.accent,
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

class _GoalStep extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileSetupNotifierProvider);
    final notifier = ref.read(profileSetupNotifierProvider.notifier);

    const goalEmojis = {
      GoalType.lose: '📉',
      GoalType.maintain: '⚖️',
      GoalType.gain: '📈',
    };

    return _StepContainer(
      emoji: '🎯',
      title: 'Votre objectif',
      child: Column(
        children: GoalType.values.map((goal) {
          final selected = state.goalType == goal;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () => notifier.setGoal(goal),
              child: AnimatedContainer(
                duration: AppConstants.animationFast,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.accent.withValues(alpha: 0.1)
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: selected ? AppColors.accent : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      goalEmojis[goal]!,
                      style: const TextStyle(fontSize: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        goal.label,
                        style: AppTextStyles.headlineSmall.copyWith(
                          color: selected ? AppColors.accent : null,
                        ),
                      ),
                    ),
                    if (selected)
                      const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.accent,
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

// ---------------------------------------------------------------------------
// Composants réutilisables
// ---------------------------------------------------------------------------

class _StepContainer extends StatelessWidget {
  const _StepContainer({
    required this.emoji,
    required this.title,
    required this.child,
    this.subtitle,
  });

  final String emoji;
  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 48))
              .animate()
              .scale(delay: 50.ms, curve: Curves.elasticOut),
          const SizedBox(height: 16),
          Text(
            title,
            style: AppTextStyles.displaySmall,
          ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.1),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.grey500,
              ),
            ).animate().fadeIn(delay: 150.ms),
          ],
          const SizedBox(height: 32),
          child.animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
        ],
      ),
    );
  }
}

class _SliderField extends StatelessWidget {
  const _SliderField({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.unit,
    required this.onChanged,
    this.decimals = 0,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String unit;
  final ValueChanged<double> onChanged;
  final int decimals;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.labelLarge),
            Text(
              decimals == 0
                  ? '${value.round()} $unit'
                  : '${value.toStringAsFixed(decimals)} $unit',
              style: AppTextStyles.headlineMedium.copyWith(
                color: AppColors.accent,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
