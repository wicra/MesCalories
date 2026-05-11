import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/providers.dart';
import '../../../auth/domain/entities/user_profile.dart';

// ---------------------------------------------------------------------------
// Page principale du flux de configuration
// ---------------------------------------------------------------------------

class SetupFlowPage extends ConsumerStatefulWidget {
  const SetupFlowPage({super.key});

  @override
  ConsumerState<SetupFlowPage> createState() => _SetupFlowPageState();
}

class _SetupFlowPageState extends ConsumerState<SetupFlowPage> {
  final _pageController = PageController();
  int _step = 0;

  // Étapes: 0=welcome, 6=goal, 7=targetWeight(si lose), 8-11=IA (ou 7-10 si pas lose)
  // Le PageView a toujours 12 pages (0-11), on skip 7 si goal != lose
  static const int _lastStep = 11;

  // --- Profil ---
  final _nameController = TextEditingController();
  BiologicalSex? _sex;
  double _age = 28;
  double _weight = 70;
  double _height = 170;
  ActivityLevel? _activity;
  GoalType? _goal;
  double _targetWeight = 65;

  // --- IA ---
  AiProvider? _provider;
  final _apiKeyController = TextEditingController();
  bool _showApiKey = false;
  final _baseUrlController = TextEditingController();
  final _modelController = TextEditingController();

  bool _isSaving = false;

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _apiKeyController.dispose();
    _baseUrlController.dispose();
    _modelController.dispose();
    super.dispose();
  }

  bool get _canContinue => switch (_step) {
        0 => true,
        1 => _nameController.text.trim().isNotEmpty,
        2 => _sex != null,
        3 => true,
        4 => true,
        5 => _activity != null,
        6 => _goal != null,
        7 => true, // targetWeight (toujours valide)
        8 => _provider != null,
        9 => _provider == AiProvider.custom ||
            _apiKeyController.text.trim().isNotEmpty,
        10 => _baseUrlController.text.trim().isNotEmpty,
        11 => _modelController.text.trim().isNotEmpty,
        _ => false,
      };

  String get _buttonLabel =>
      _step == _lastStep ? 'C\'est parti !' : 'Continuer';

  void _goTo(int step) {
    setState(() => _step = step);
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeInOutCubic,
    );
  }

  Future<void> _next() async {
    if (_step == _lastStep) {
      await _saveAndFinish();
      return;
    }
    // Sauter l'étape targetWeight si l'objectif n'est pas "perdre du poids"
    final nextStep =
        (_step == 6 && _goal != GoalType.lose) ? 8 : _step + 1;
    _goTo(nextStep);
  }

  void _prev() {
    if (_step <= 1) return;
    // Sauter l'étape targetWeight en arrière si l'objectif n'est pas "perdre du poids"
    final prevStep =
        (_step == 8 && _goal != GoalType.lose) ? 6 : _step - 1;
    _goTo(prevStep);
  }

  Future<void> _saveAndFinish() async {
    FocusScope.of(context).unfocus();
    setState(() => _isSaving = true);
    try {
      final profileRepo = ref.read(userProfileRepositoryProvider);
      final goals = profileRepo.computeGoals(
        age: _age.round(),
        sex: _sex!,
        weightKg: _weight,
        heightCm: _height,
        activity: _activity!,
        goal: _goal!,
      );
      final now = DateTime.now();
      await profileRepo.saveProfile(UserProfile(
        id: 0,
        firstName: _nameController.text.trim(),
        age: _age.round(),
        biologicalSex: _sex!,
        weightKg: _weight,
        heightCm: _height,
        activityLevel: _activity!,
        goalType: _goal!,
        dailyCalorieGoal: goals.calorieGoal,
        proteinGoalG: goals.proteinGoalG,
        carbGoalG: goals.carbGoalG,
        fatGoalG: goals.fatGoalG,
        createdAt: now,
        updatedAt: now,
      ));

      final prefs = ref.read(preferencesServiceProvider);
      await prefs.saveApiKey(_provider!, _apiKeyController.text.trim());
      await prefs.saveBaseUrl(_provider!, _baseUrlController.text.trim());
      await prefs.saveModelName(_provider!, _modelController.text.trim());
      await prefs.setSelectedProvider(_provider!);
      await prefs.setDailyCalorieGoal(goals.calorieGoal);
      await prefs.setOnboardingCompleted(true);

      if (mounted) context.go(AppRoutes.dashboard);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur : $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              _Header(
                step: _step,
                totalSteps: _lastStep,
                onBack: _step > 1 ? _prev : null,
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _WelcomeStep(onStart: _next),
                    _NameStep(
                        controller: _nameController,
                        onChanged: () => setState(() {}),
                        onSubmit: _canContinue ? _next : null),
                    _SexStep(
                        selected: _sex,
                        onSelect: (s) {
                          setState(() => _sex = s);
                          _next();
                        }),
                    _AgeStep(
                        age: _age, onChanged: (v) => setState(() => _age = v)),
                    _MeasurementsStep(
                        weight: _weight,
                        height: _height,
                        onWeightChanged: (v) => setState(() => _weight = v),
                        onHeightChanged: (v) => setState(() => _height = v)),
                    _ActivityStep(
                        selected: _activity,
                        onSelect: (a) {
                          setState(() => _activity = a);
                          _next();
                        }),
                    _GoalStep(
                        selected: _goal,
                        onSelect: (g) {
                          setState(() => _goal = g);
                          _next();
                        }),
                    // Étape 7 — poids cible (uniquement si GoalType.lose)
                    _TargetWeightStep(
                        currentWeight: _weight,
                        targetWeight: _targetWeight,
                        onChanged: (v) => setState(() => _targetWeight = v)),
                    _ProviderStep(
                        selected: _provider,
                        onSelect: (p) {
                          setState(() {
                            _provider = p;
                            _baseUrlController.text = switch (p) {
                              AiProvider.groq => AppConstants.hintGroqBaseUrl,
                              AiProvider.mistral =>
                                AppConstants.hintMistralBaseUrl,
                              AiProvider.openai => AppConstants.hintOpenAiBaseUrl,
                              AiProvider.gemini => AppConstants.hintGeminiBaseUrl,
                              AiProvider.anthropic =>
                                AppConstants.hintAnthropicBaseUrl,
                              AiProvider.custom => '',
                            };
                            _modelController.text = switch (p) {
                              AiProvider.groq => AppConstants.hintGroqModel,
                              AiProvider.mistral =>
                                AppConstants.hintMistralModel,
                              AiProvider.openai => AppConstants.hintOpenAiModel,
                              AiProvider.gemini => AppConstants.hintGeminiModel,
                              AiProvider.anthropic =>
                                AppConstants.hintAnthropicModel,
                              AiProvider.custom => '',
                            };
                          });
                          _next();
                        }),
                    _ApiKeyStep(
                        provider: _provider,
                        controller: _apiKeyController,
                        showKey: _showApiKey,
                        onToggleShow: () =>
                            setState(() => _showApiKey = !_showApiKey),
                        onChanged: () => setState(() {})),
                    _BaseUrlStep(
                        provider: _provider,
                        controller: _baseUrlController,
                        onChanged: () => setState(() {})),
                    _ModelStep(
                        provider: _provider,
                        controller: _modelController,
                        onChanged: () => setState(() {})),
                  ],
                ),
              ),
              if (_step > 0)
                _BottomButton(
                  label: _buttonLabel,
                  enabled: _canContinue && !_isSaving,
                  loading: _isSaving,
                  onPressed: _next,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Header avec barre de progression
// ---------------------------------------------------------------------------

class _Header extends StatelessWidget {
  const _Header({required this.step, required this.totalSteps, this.onBack});

  final int step;
  final int totalSteps;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    if (step == 0) return const SizedBox.shrink();
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 3,
          child: LinearProgressIndicator(
            value: step / totalSteps,
            backgroundColor:
                Theme.of(context).colorScheme.surfaceContainerHighest,
            valueColor: const AlwaysStoppedAnimation(AppColors.accent),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 4, 16, 0),
          child: Row(
            children: [
              if (onBack != null)
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_rounded, size: 18),
                  onPressed: onBack,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6),
                )
              else
                const SizedBox(width: 48),
              const Spacer(),
              Text(
                '$step / $totalSteps',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.4),
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Bouton bas de page
// ---------------------------------------------------------------------------

class _BottomButton extends StatelessWidget {
  const _BottomButton({
    required this.label,
    required this.enabled,
    required this.loading,
    required this.onPressed,
  });

  final String label;
  final bool enabled;
  final bool loading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: enabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
            foregroundColor: Colors.white,
            disabledBackgroundColor: AppColors.accent.withValues(alpha: 0.3),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: loading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
              : Text(label,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Container générique pour les étapes
// ---------------------------------------------------------------------------

class _StepBody extends StatelessWidget {
  const _StepBody({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.child,
    this.scrollable = false,
  });

  final String emoji;
  final String title;
  final String subtitle;
  final Widget child;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 48))
              .animate()
              .scale(duration: 400.ms, curve: Curves.elasticOut),
          const SizedBox(height: 12),
          Text(title,
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.w700))
              .animate()
              .fadeIn(delay: 80.ms)
              .slideX(begin: 0.05, end: 0),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.55),
                ),
          ).animate().fadeIn(delay: 160.ms),
          const SizedBox(height: 28),
          child.animate().fadeIn(delay: 240.ms).slideY(begin: 0.06, end: 0),
        ],
      ),
    );

    if (scrollable) return SingleChildScrollView(child: content);
    return content;
  }
}

// ---------------------------------------------------------------------------
// Étapes
// ---------------------------------------------------------------------------

class _WelcomeStep extends StatelessWidget {
  const _WelcomeStep({required this.onStart});
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          const SizedBox(height: 48),
          const Text('🥗', style: TextStyle(fontSize: 88))
              .animate()
              .scale(duration: 700.ms, curve: Curves.elasticOut),
          const SizedBox(height: 32),
          Text(
            'MesCalories',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 12),
          Text(
            'Ton assistant nutrition\nalimenté par l\'IA',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.55),
                ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 350.ms),
          const SizedBox(height: 52),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: onStart,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Commencer',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
            ),
          ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2, end: 0),
          const SizedBox(height: 20),
          Text(
            '2 minutes • Local • Privé',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.35),
                ),
          ).animate().fadeIn(delay: 700.ms),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _NameStep extends StatelessWidget {
  const _NameStep(
      {required this.controller, required this.onChanged, this.onSubmit});
  final TextEditingController controller;
  final VoidCallback onChanged;
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    return _StepBody(
      emoji: '👋',
      title: 'Comment tu t\'appelles ?',
      subtitle: 'Juste un prénom, c\'est suffisant.',
      child: TextField(
        controller: controller,
        autofocus: true,
        textCapitalization: TextCapitalization.words,
        style: Theme.of(context).textTheme.headlineSmall,
        decoration: InputDecoration(
          hintText: 'Ton prénom',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        ),
        onChanged: (_) => onChanged(),
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => onSubmit?.call(),
      ),
    );
  }
}

class _SexStep extends StatelessWidget {
  const _SexStep({required this.selected, required this.onSelect});
  final BiologicalSex? selected;
  final ValueChanged<BiologicalSex> onSelect;

  @override
  Widget build(BuildContext context) {
    return _StepBody(
      emoji: '👤',
      title: 'Tu es ?',
      subtitle: 'Pour calculer ton métabolisme de base.',
      child: Row(
        children: BiologicalSex.values.map((sex) {
          final isSelected = selected == sex;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: GestureDetector(
                onTap: () => onSelect(sex),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 28),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.accent
                        : Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? AppColors.accent : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(sex == BiologicalSex.male ? '👨' : '👩',
                          style: const TextStyle(fontSize: 44)),
                      const SizedBox(height: 10),
                      Text(
                        sex.label,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: isSelected
                              ? Colors.white
                              : Theme.of(context).colorScheme.onSurface,
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

class _AgeStep extends StatelessWidget {
  const _AgeStep({required this.age, required this.onChanged});
  final double age;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return _StepBody(
      emoji: '🎂',
      title: 'Quel âge as-tu ?',
      subtitle: 'Glisse pour sélectionner.',
      child: Column(
        children: [
          Text(
            '${age.round()} ans',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 24),
          _StyledSlider(
              value: age,
              min: 10,
              max: 100,
              divisions: 90,
              onChanged: onChanged),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('10 ans',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.4))),
              Text('100 ans',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.4))),
            ],
          ),
        ],
      ),
    );
  }
}

class _MeasurementsStep extends StatelessWidget {
  const _MeasurementsStep({
    required this.weight,
    required this.height,
    required this.onWeightChanged,
    required this.onHeightChanged,
  });
  final double weight;
  final double height;
  final ValueChanged<double> onWeightChanged;
  final ValueChanged<double> onHeightChanged;

  @override
  Widget build(BuildContext context) {
    return _StepBody(
      emoji: '⚖️',
      title: 'Quelques chiffres...',
      subtitle: 'Pour calibrer tes objectifs personnalisés.',
      child: Column(
        children: [
          _SliderRow(
              label: 'Poids',
              value: weight,
              unit: 'kg',
              min: 30,
              max: 200,
              divisions: 340,
              onChanged: onWeightChanged),
          const SizedBox(height: 28),
          _SliderRow(
              label: 'Taille',
              value: height,
              unit: 'cm',
              min: 130,
              max: 230,
              divisions: 200,
              onChanged: onHeightChanged),
        ],
      ),
    );
  }
}

class _SliderRow extends StatelessWidget {
  const _SliderRow({
    required this.label,
    required this.value,
    required this.unit,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
  });
  final String label;
  final double value;
  final String unit;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.6))),
            Text(
              '${value.round()} $unit',
              style: const TextStyle(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w800,
                  fontSize: 20),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _StyledSlider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged),
      ],
    );
  }
}

class _StyledSlider extends StatelessWidget {
  const _StyledSlider(
      {required this.value,
      required this.min,
      required this.max,
      required this.divisions,
      required this.onChanged});
  final double value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 6,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 13),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 22),
        activeTrackColor: AppColors.accent,
        thumbColor: AppColors.accent,
        overlayColor: AppColors.accent.withValues(alpha: 0.15),
        inactiveTrackColor:
            Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged),
    );
  }
}

class _ActivityStep extends StatelessWidget {
  const _ActivityStep({required this.selected, required this.onSelect});
  final ActivityLevel? selected;
  final ValueChanged<ActivityLevel> onSelect;

  @override
  Widget build(BuildContext context) {
    return _StepBody(
      emoji: '🏃',
      title: 'Ton niveau d\'activité ?',
      subtitle: 'Sois honnête, ça change tout.',
      scrollable: true,
      child: Column(
        children: ActivityLevel.values.map((level) {
          final isSelected = selected == level;
          return _SelectionCard(
            isSelected: isSelected,
            onTap: () => onSelect(level),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? AppColors.accent : Colors.transparent,
                    border: Border.all(
                        color: isSelected
                            ? AppColors.accent
                            : Theme.of(context).colorScheme.outline,
                        width: 2),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(level.label,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? AppColors.accent
                                  : Theme.of(context).colorScheme.onSurface)),
                      Text(level.description,
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withValues(alpha: 0.5))),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _GoalStep extends StatelessWidget {
  const _GoalStep({required this.selected, required this.onSelect});
  final GoalType? selected;
  final ValueChanged<GoalType> onSelect;

  @override
  Widget build(BuildContext context) {
    const emojis = {
      GoalType.lose: '📉',
      GoalType.maintain: '⚖️',
      GoalType.gain: '💪'
    };
    return _StepBody(
      emoji: '🎯',
      title: 'Ton objectif ?',
      subtitle: 'On adapte les calories et macros pour toi.',
      child: Column(
        children: GoalType.values.map((goal) {
          final isSelected = selected == goal;
          return _SelectionCard(
            isSelected: isSelected,
            onTap: () => onSelect(goal),
            child: Row(
              children: [
                Text(emojis[goal]!, style: const TextStyle(fontSize: 36)),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    goal.label,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: isSelected
                          ? AppColors.accent
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.check_circle_rounded,
                      color: AppColors.accent),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _TargetWeightStep extends StatelessWidget {
  const _TargetWeightStep({
    required this.currentWeight,
    required this.targetWeight,
    required this.onChanged,
  });
  final double currentWeight;
  final double targetWeight;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final diff = (currentWeight - targetWeight).abs();
    return _StepBody(
      emoji: '🎯',
      title: 'Quel est ton poids cible ?',
      subtitle: 'Tu définiras ton rythme de progression.',
      child: Column(
        children: [
          Text(
            '${targetWeight.round()} kg',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            targetWeight < currentWeight
                ? '− ${diff.round()} kg à perdre'
                : '+ ${diff.round()} kg au-dessus du poids actuel',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.5),
                ),
          ),
          const SizedBox(height: 24),
          _StyledSlider(
            value: targetWeight,
            min: 30,
            max: 200,
            divisions: 340,
            onChanged: onChanged,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('30 kg',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.4))),
              Text('200 kg',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.4))),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProviderStep extends StatelessWidget {
  const _ProviderStep({required this.selected, required this.onSelect});
  final AiProvider? selected;
  final ValueChanged<AiProvider> onSelect;

  @override
  Widget build(BuildContext context) {
    final providers = [
      (
        AiProvider.groq,
        '⚡',
        'Groq',
        'LLaMA 3.3 70B — rapide & gratuit',
        'console.groq.com/keys'
      ),
      (
        AiProvider.mistral,
        '💨',
        'Mistral',
        'Mistral Small — gratuit',
        'console.mistral.ai/api-keys'
      ),
      (
        AiProvider.openai,
        '🟢',
        'OpenAI',
        'Modèles GPT — le plus courant',
        'platform.openai.com/api-keys'
      ),
      (
        AiProvider.gemini,
        '🔵',
        'Google Gemini',
        'Gemini Flash, Pro...',
        'aistudio.google.com/app/apikey'
      ),
      (
        AiProvider.anthropic,
        '🟣',
        'Anthropic Claude',
        'Claude Opus, Sonnet...',
        'console.anthropic.com/settings/keys'
      ),
      (
        AiProvider.custom,
        '⚙️',
        'Personnalisé',
        'Toute API compatible OpenAI',
        ''
      ),
    ];

    return _StepBody(
      emoji: '🤖',
      title: 'Quel assistant IA ?',
      subtitle: 'Tu auras besoin d\'une clé API gratuite ou payante.',
      child: Column(
        children: providers.map((item) {
          final (provider, dot, name, desc, site) = item;
          final isSelected = selected == provider;
          return _SelectionCard(
            isSelected: isSelected,
            onTap: () => onSelect(provider),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(dot, style: const TextStyle(fontSize: 28)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: isSelected
                                  ? AppColors.accent
                                  : Theme.of(context).colorScheme.onSurface)),
                      Text(desc,
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withValues(alpha: 0.55))),
                      Text('Clé sur : $site',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                                  color:
                                      AppColors.accent.withValues(alpha: 0.7),
                                  fontSize: 10)),
                    ],
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.check_circle_rounded,
                      color: AppColors.accent),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ApiKeyStep extends StatelessWidget {
  const _ApiKeyStep({
    required this.provider,
    required this.controller,
    required this.showKey,
    required this.onToggleShow,
    required this.onChanged,
  });
  final AiProvider? provider;
  final TextEditingController controller;
  final bool showKey;
  final VoidCallback onToggleShow;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final providerName = provider?.label ?? 'IA';
    final site = switch (provider) {
      AiProvider.groq => 'console.groq.com/keys',
      AiProvider.mistral => 'console.mistral.ai/api-keys',
      AiProvider.openai => 'platform.openai.com/api-keys',
      AiProvider.gemini => 'aistudio.google.com/app/apikey',
      AiProvider.anthropic => 'console.anthropic.com/settings/keys',
      AiProvider.custom => '',
      null => '',
    };
    final hint = switch (provider) {
      AiProvider.groq => 'gsk_...',
      AiProvider.mistral => 'Clé Mistral',
      AiProvider.openai => 'sk-...',
      AiProvider.gemini => 'AIza...',
      AiProvider.anthropic => 'sk-ant-...',
      AiProvider.custom => 'Clé API (optionnelle)',
      null => 'Clé API',
    };

    return _StepBody(
      emoji: '🔑',
      title: 'Ta clé API $providerName',
      subtitle: 'Chiffrée sur ton appareil. Jamais partagée.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            autofocus: true,
            obscureText: !showKey,
            autocorrect: false,
            enableSuggestions: false,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 14),
            decoration: InputDecoration(
              hintText: hint,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              suffixIcon: IconButton(
                icon: Icon(
                    showKey
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                    size: 20),
                onPressed: onToggleShow,
              ),
            ),
            onChanged: (_) => onChanged(),
          ),
          const SizedBox(height: 14),
          _InfoTile(
            text: site.isEmpty ? '' : 'Où la trouver : $site',
            icon: Icons.info_outline_rounded,
          ),
        ],
      ),
    );
  }
}

class _BaseUrlStep extends StatelessWidget {
  const _BaseUrlStep(
      {required this.provider,
      required this.controller,
      required this.onChanged});
  final AiProvider? provider;
  final TextEditingController controller;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final hint = switch (provider) {
      AiProvider.groq => AppConstants.hintGroqBaseUrl,
      AiProvider.mistral => AppConstants.hintMistralBaseUrl,
      AiProvider.openai => AppConstants.hintOpenAiBaseUrl,
      AiProvider.gemini => AppConstants.hintGeminiBaseUrl,
      AiProvider.anthropic => AppConstants.hintAnthropicBaseUrl,
      AiProvider.custom => AppConstants.hintCustomBaseUrl,
      null => 'https://api.example.com/v1',
    };

    return _StepBody(
      emoji: '🌐',
      title: 'URL de base de l\'API',
      subtitle: 'Le point d\'entrée de l\'API. Colle ou tape l\'URL.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            autofocus: true,
            autocorrect: false,
            keyboardType: TextInputType.url,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
            decoration: InputDecoration(
              hintText: hint,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            ),
            onChanged: (_) => onChanged(),
          ),
          const SizedBox(height: 14),
          _InfoTile(text: 'Exemple : $hint'),
        ],
      ),
    );
  }
}

class _ModelStep extends StatelessWidget {
  const _ModelStep(
      {required this.provider,
      required this.controller,
      required this.onChanged});
  final AiProvider? provider;
  final TextEditingController controller;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final hint = switch (provider) {
      AiProvider.groq => AppConstants.hintGroqModel,
      AiProvider.mistral => AppConstants.hintMistralModel,
      AiProvider.openai => AppConstants.hintOpenAiModel,
      AiProvider.gemini => AppConstants.hintGeminiModel,
      AiProvider.anthropic => AppConstants.hintAnthropicModel,
      AiProvider.custom => AppConstants.hintCustomModel,
      null => 'model-name',
    };
    final examples = switch (provider) {
      AiProvider.groq => 'llama-3.3-70b-versatile · mixtral-8x7b-32768',
      AiProvider.mistral => 'mistral-small-latest · mistral-large-latest',
      AiProvider.openai => 'gpt-4o · gpt-4-turbo · gpt-3.5-turbo',
      AiProvider.gemini => 'gemini-2.0-flash · gemini-1.5-pro',
      AiProvider.anthropic => 'claude-opus-4-5 · claude-3-5-sonnet-20241022',
      AiProvider.custom => '',
      null => '',
    };

    return _StepBody(
      emoji: '⚙️',
      title: 'Quel modèle ?',
      subtitle: 'Le modèle utilisé pour analyser tes repas.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            autofocus: true,
            autocorrect: false,
            style: const TextStyle(fontFamily: 'monospace'),
            decoration: InputDecoration(
              hintText: hint,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            ),
            onChanged: (_) => onChanged(),
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 14),
          _InfoTile(text: examples.isEmpty ? '' : 'Exemples : $examples'),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Widgets helper
// ---------------------------------------------------------------------------

class _SelectionCard extends StatelessWidget {
  const _SelectionCard(
      {required this.isSelected, required this.onTap, required this.child});
  final bool isSelected;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.accent.withValues(alpha: 0.07)
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.accent : Colors.transparent,
            width: isSelected ? 2 : 0,
          ),
        ),
        child: child,
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile(
      {required this.text, this.icon = Icons.lightbulb_outline_rounded});
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon,
              size: 15,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.45)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.55),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
