import 'dart:ui';
import 'dart:async' show unawaited;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../core/services/widget_service.dart';
import '../../../tracking/presentation/providers/tracking_provider.dart';
import '../../../auth/presentation/providers/profile_provider.dart';

/// Page principale — tableau de bord journalier. Style Liquid Glass premium.
class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = DateTime.now();
    final summaryAsync = ref.watch(dailySummaryProvider(today));
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.black,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _GlassAppBar(profileAsync: profileAsync),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.horizontalPadding,
            ),
            sliver: summaryAsync.when(
              loading: () => const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.accent,
                    strokeWidth: 1.5,
                  ),
                ),
              ),
              error: (e, _) => SliverFillRemaining(
                child: Center(
                  child: Text(
                    'Erreur : $e',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ),
              ),
              data: (summary) {
                unawaited(WidgetService.update(
                  caloriesToday: summary.totalCalories,
                  calorieGoal: summary.calorieGoal,
                ));
                return SliverList(
                  delegate: SliverChildListDelegate([
                  const SizedBox(height: 8),
                  _CalorieGlassCard(summary: summary),
                  const SizedBox(height: 14),
                  _MacrosRow(summary: summary),
                  const SizedBox(height: 28),
                  _SectionTitle(date: today),
                  const SizedBox(height: 12),
                  if (summary.entries.isEmpty)
                    const _EmptyState()
                  else
                    ...summary.entries.map((e) => _MealCard(entry: e)),
                  const SizedBox(height: 100),
                ]),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: _GlassFab(
        onPressed: () => context.go(AppRoutes.tracking),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// App Bar Glassmorphism
// ---------------------------------------------------------------------------

class _GlassAppBar extends StatelessWidget {
  const _GlassAppBar({required this.profileAsync});
  final AsyncValue profileAsync;

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Bonjour';
    if (h < 18) return 'Bon après-midi';
    return 'Bonsoir';
  }

  @override
  Widget build(BuildContext context) {
    final firstName = profileAsync.valueOrNull?.firstName ?? '';

    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(color: Colors.transparent),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('EEEE d MMMM', 'fr_FR').format(DateTime.now()),
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
              letterSpacing: 0.3,
            ),
          ),
          Text(
            firstName.isNotEmpty ? '${_greeting()}, $firstName' : _greeting(),
            style: AppTextStyles.headlineMedium.copyWith(
              color: AppColors.white,
            ),
          ),
        ],
      ),
      actions: [
        GestureDetector(
          onTap: () => context.go(AppRoutes.settings),
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.glassWhite,
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: const Icon(
              Icons.person_outline_rounded,
              color: AppColors.white,
              size: 18,
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Carte Calorie — Anneau avec glow + Glass
// ---------------------------------------------------------------------------

class _CalorieGlassCard extends StatelessWidget {
  const _CalorieGlassCard({required this.summary});
  final dynamic summary;

  @override
  Widget build(BuildContext context) {
    final progress = (summary.calorieProgress as double).clamp(0.0, 1.0);
    final total = summary.totalCalories as int;
    final goal = summary.calorieGoal as int;
    final remaining = summary.remainingCalories as int;

    final ringColor = progress >= 1.0
        ? AppColors.error
        : progress > 0.85
            ? AppColors.warning
            : AppColors.accent;

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(AppConstants.cardPadding),
          decoration: BoxDecoration(
            color: AppColors.glassWhite,
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 110,
                height: 110,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: ringColor.withValues(alpha: 0.2),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                    ),
                    CustomPaint(
                      size: const Size(110, 110),
                      painter: _GlowRingPainter(
                        progress: progress,
                        color: ringColor,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$total',
                          style: AppTextStyles.numeralMedium.copyWith(
                            color: ringColor,
                            fontSize: 26,
                          ),
                        ),
                        Text(
                          'kcal',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate().scale(delay: 100.ms, curve: Curves.elasticOut),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Objectif journalier',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$goal kcal',
                      style: AppTextStyles.headlineMedium.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _GlassProgressBar(progress: progress, color: ringColor),
                    const SizedBox(height: 10),
                    Text(
                      remaining > 0
                          ? '$remaining kcal restantes'
                          : '${(-remaining)} kcal dépassées',
                      style: AppTextStyles.labelSmall.copyWith(
                        color:
                            remaining > 0 ? AppColors.success : AppColors.error,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: 50.ms).slideY(begin: 0.05);
  }
}

class _GlassProgressBar extends StatelessWidget {
  const _GlassProgressBar({required this.progress, required this.color});
  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: SizedBox(
        height: 5,
        child: Stack(
          children: [
            Container(color: AppColors.glassWhite),
            FractionallySizedBox(
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.5),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Macros — Liquid Glass pills
// ---------------------------------------------------------------------------

class _MacrosRow extends StatelessWidget {
  const _MacrosRow({required this.summary});
  final dynamic summary;

  @override
  Widget build(BuildContext context) {
    final macros = [
      (
        'Prot',
        summary.totalProteinsG,
        summary.proteinGoalG,
        AppColors.proteins
      ),
      ('Gluc', summary.totalCarbsG, summary.carbGoalG, AppColors.carbs),
      ('Lip', summary.totalFatsG, summary.fatGoalG, AppColors.fats),
    ];

    return Row(
      children: macros.asMap().entries.map((e) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: e.key == 0 ? 0 : 6,
              right: e.key == 2 ? 0 : 6,
            ),
            child: _MacroGlassPill(
              label: e.value.$1,
              current: e.value.$2,
              goal: e.value.$3.toDouble(),
              color: e.value.$4,
            ),
          ),
        );
      }).toList(),
    ).animate().fadeIn(delay: 200.ms);
  }
}

class _MacroGlassPill extends StatelessWidget {
  const _MacroGlassPill({
    required this.label,
    required this.current,
    required this.goal,
    required this.color,
  });

  final String label;
  final double current;
  final double goal;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final progress = (current / goal).clamp(0.0, 1.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.glassWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${current.toStringAsFixed(0)}g',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '/ ${goal.toStringAsFixed(0)}g',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: SizedBox(
                  height: 3,
                  child: Stack(
                    children: [
                      Container(color: color.withValues(alpha: 0.15)),
                      FractionallySizedBox(
                        widthFactor: progress,
                        child: Container(color: color),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Section titre
// ---------------------------------------------------------------------------

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.date});
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Aujourd'hui",
          style: AppTextStyles.headlineSmall.copyWith(color: AppColors.white),
        ),
        Text(
          DateFormat('d MMM', 'fr_FR').format(date),
          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// État vide
// ---------------------------------------------------------------------------

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 52),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.glassWhite,
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: const Icon(
              Icons.restaurant_outlined,
              color: AppColors.textSecondary,
              size: 28,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Aucun repas enregistré',
            style: AppTextStyles.headlineSmall.copyWith(color: AppColors.white),
          ),
          const SizedBox(height: 8),
          Text(
            'Commencez à tracker\nvos repas du jour.',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms);
  }
}

// ---------------------------------------------------------------------------
// Carte repas — Liquid Glass
// ---------------------------------------------------------------------------

class _MealCard extends StatelessWidget {
  const _MealCard({required this.entry});
  final dynamic entry;

  @override
  Widget build(BuildContext context) {
    final time = DateFormat('HH:mm').format(entry.loggedAt as DateTime);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.glassWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.accentDim,
                  border: Border.all(
                    color: AppColors.accent.withValues(alpha: 0.3),
                  ),
                ),
                child: const Icon(
                  Icons.restaurant_rounded,
                  color: AppColors.accent,
                  size: 18,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.aiSummary as String,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      time,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${entry.calories}',
                    style: AppTextStyles.headlineSmall.copyWith(
                      color: AppColors.accent,
                    ),
                  ),
                  Text(
                    'kcal',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn().slideX(begin: 0.03);
  }
}

// ---------------------------------------------------------------------------
// FAB Glass premium
// ---------------------------------------------------------------------------

class _GlassFab extends StatelessWidget {
  const _GlassFab({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add_rounded, color: AppColors.black, size: 22),
            const SizedBox(width: 8),
            Text(
              'Ajouter',
              style: AppTextStyles.buttonSmall.copyWith(color: AppColors.black),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Anneau premium avec glow
// ---------------------------------------------------------------------------

class _GlowRingPainter extends CustomPainter {
  const _GlowRingPainter({required this.progress, required this.color});
  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 14) / 2;
    const strokeWidth = 8.0;
    const startAngle = -1.5707963;
    final sweepAngle = 2 * 3.14159265 * progress;

    final bgPaint = Paint()
      ..color = AppColors.glassBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 4
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    final fgPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        glowPaint,
      );
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        fgPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_GlowRingPainter old) =>
      old.progress != progress || old.color != color;
}
