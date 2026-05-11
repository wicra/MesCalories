import 'dart:math' as math;
import 'dart:async' show unawaited;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../core/services/widget_service.dart';
import '../../../tracking/presentation/providers/tracking_provider.dart';
import '../../../auth/presentation/providers/profile_provider.dart';

/// Dashboard journalier — Design System premium, sobre, Finance-app style.
class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final summaryAsync = ref.watch(dailySummaryProvider(today));
    final profileAsync = ref.watch(userProfileProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;

    return Scaffold(
      backgroundColor: bg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _DashboardAppBar(profileAsync: profileAsync, isDark: isDark),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.pagePadding,
            ),
            sliver: summaryAsync.when(
              loading: () => const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.accent,
                    strokeWidth: 2,
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
                    const SizedBox(height: AppSpacing.sm),
                    _CalorieCard(summary: summary, isDark: isDark),
                    const SizedBox(height: AppSpacing.md),
                    _MacrosRow(summary: summary, isDark: isDark),
                    const SizedBox(height: AppSpacing.xl),
                    _SectionHeader(date: today, isDark: isDark),
                    const SizedBox(height: AppSpacing.md),
                    if (summary.entries.isEmpty)
                      _EmptyState(isDark: isDark)
                    else
                      ...summary.entries.map(
                        (e) => _MealCard(entry: e, isDark: isDark),
                      ),
                    const SizedBox(height: 110),
                  ]),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: _AddFAB(
        onPressed: () => context.go(AppRoutes.tracking),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// App Bar — propre, minimaliste
// ---------------------------------------------------------------------------

class _DashboardAppBar extends StatelessWidget {
  const _DashboardAppBar({required this.profileAsync, required this.isDark});
  final AsyncValue profileAsync;
  final bool isDark;

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Bonjour';
    if (h < 18) return 'Bon après-midi';
    return 'Bonsoir';
  }

  @override
  Widget build(BuildContext context) {
    final firstName = profileAsync.valueOrNull?.firstName ?? '';
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subColor =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;

    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: bg,
      elevation: 0,
      scrolledUnderElevation: 0,
      toolbarHeight: 72,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('EEEE d MMMM', 'fr_FR').format(DateTime.now()),
            style: AppTextStyles.caption
                .copyWith(color: subColor, letterSpacing: 0.2),
          ),
          const SizedBox(height: 2),
          Text(
            firstName.isNotEmpty
                ? '${_greeting()}, $firstName 👋'
                : _greeting(),
            style: AppTextStyles.headlineMedium.copyWith(color: textColor),
          ),
        ],
      ),
      actions: [
        GestureDetector(
          onTap: () => context.go(AppRoutes.settings),
          child: Container(
            margin: const EdgeInsets.only(right: AppSpacing.lg),
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
              boxShadow: isDark ? [] : AppShadows.soft,
            ),
            child: Icon(
              Icons.person_outline_rounded,
              color: subColor,
              size: 18,
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Carte Calorie — Arc gauge, propre
// ---------------------------------------------------------------------------

class _CalorieCard extends StatelessWidget {
  const _CalorieCard({required this.summary, required this.isDark});
  final dynamic summary;
  final bool isDark;

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

    final cardBg = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subColor =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final trackColor =
        isDark ? AppColors.darkSurface3 : AppColors.lightSurface3;

    final hour = DateTime.now().hour;
    final String timeHint = hour < 12
        ? 'Matin · journée devant toi'
        : hour < 14
            ? 'Heure du déjeuner'
            : hour < 18
                ? 'Après-midi · reste actif'
                : 'Soirée · presque terminé';

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.cardPadding,
        AppSpacing.xl,
        AppSpacing.cardPadding,
        AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: border),
        boxShadow: isDark ? [] : AppShadows.card,
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 170,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(220, 170),
                  painter: _ArcGaugePainter(
                    progress: progress,
                    color: ringColor,
                    trackColor: trackColor,
                  ),
                ),
                Positioned(
                  bottom: 12,
                  child: Column(
                    children: [
                      Text(
                        '$total',
                        style: AppTextStyles.numeralLarge
                            .copyWith(color: textColor),
                      ),
                      Text(
                        'sur $goal kcal',
                        style:
                            AppTextStyles.bodySmall.copyWith(color: subColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    remaining > 0
                        ? '$remaining kcal restantes'
                        : '${-remaining} kcal dépassées',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: remaining > 0 ? AppColors.success : AppColors.error,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    timeHint,
                    style: AppTextStyles.caption.copyWith(color: subColor),
                  ),
                ],
              ),
              _ProgressBadge(progress: progress, ringColor: ringColor),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 50.ms).slideY(begin: 0.04);
  }
}

// ---------------------------------------------------------------------------
// Badge de progression
// ---------------------------------------------------------------------------

class _ProgressBadge extends StatelessWidget {
  const _ProgressBadge({required this.progress, required this.ringColor});
  final double progress;
  final Color ringColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: ringColor.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppRadius.badge),
        border: Border.all(color: ringColor.withValues(alpha: 0.25)),
      ),
      child: Text(
        '${(progress * 100).round()}%',
        style: AppTextStyles.labelMedium.copyWith(
          color: ringColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Arc Gauge Painter — demi-cercle 180°
// ---------------------------------------------------------------------------

class _ArcGaugePainter extends CustomPainter {
  const _ArcGaugePainter({
    required this.progress,
    required this.color,
    required this.trackColor,
  });
  final double progress;
  final Color color;
  final Color trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height - 10);
    final radius = size.width * 0.42;
    const startAngle = math.pi;
    const sweepTotal = math.pi;

    final bgPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final fgPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(rect, startAngle, sweepTotal, false, bgPaint);
    if (progress > 0) {
      final sweep = sweepTotal * progress;
      canvas.drawArc(rect, startAngle, sweep, false, glowPaint);
      canvas.drawArc(rect, startAngle, sweep, false, fgPaint);
    }

    final dotPaint = Paint()..color = trackColor;
    final leftPos = Offset(
      center.dx + radius * math.cos(startAngle),
      center.dy + radius * math.sin(startAngle),
    );
    final rightPos = Offset(
      center.dx + radius * math.cos(startAngle + sweepTotal),
      center.dy + radius * math.sin(startAngle + sweepTotal),
    );
    canvas.drawCircle(leftPos, 5, dotPaint);
    canvas.drawCircle(rightPos, 5, dotPaint);
  }

  @override
  bool shouldRepaint(_ArcGaugePainter old) =>
      old.progress != progress ||
      old.color != color ||
      old.trackColor != trackColor;
}

// ---------------------------------------------------------------------------
// Macros — Row de 3 cards
// ---------------------------------------------------------------------------

class _MacrosRow extends StatelessWidget {
  const _MacrosRow({required this.summary, required this.isDark});
  final dynamic summary;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final macros = [
      ('Prot.', summary.totalProteinsG, summary.proteinGoalG, AppColors.proteins),
      ('Gluc.', summary.totalCarbsG, summary.carbGoalG, AppColors.carbs),
      ('Lip.', summary.totalFatsG, summary.fatGoalG, AppColors.fats),
    ];

    return Row(
      children: macros.asMap().entries.map((e) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: e.key == 0 ? 0 : AppSpacing.cardGap / 2,
              right: e.key == 2 ? 0 : AppSpacing.cardGap / 2,
            ),
            child: _MacroCard(
              label: e.value.$1,
              current: e.value.$2,
              goal: e.value.$3.toDouble(),
              color: e.value.$4,
              isDark: isDark,
            ),
          ),
        );
      }).toList(),
    ).animate().fadeIn(delay: 150.ms);
  }
}

class _MacroCard extends StatelessWidget {
  const _MacroCard({
    required this.label,
    required this.current,
    required this.goal,
    required this.color,
    required this.isDark,
  });
  final String label;
  final double current;
  final double goal;
  final Color color;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final progress = goal > 0 ? (current / goal).clamp(0.0, 1.0) : 0.0;
    final cardBg = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subColor =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final trackColor =
        isDark ? AppColors.darkSurface3 : AppColors.lightSurface3;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(AppRadius.cardSmall),
        border: Border.all(color: border),
        boxShadow: isDark ? [] : AppShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(shape: BoxShape.circle, color: color),
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${current.toStringAsFixed(0)}g',
            style: AppTextStyles.headlineSmall.copyWith(
              color: textColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            '/${goal.toStringAsFixed(0)}g',
            style: AppTextStyles.caption.copyWith(color: subColor),
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: SizedBox(
              height: 4,
              child: Stack(
                children: [
                  Container(color: trackColor),
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
    );
  }
}

// ---------------------------------------------------------------------------
// Section header
// ---------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.date, required this.isDark});
  final DateTime date;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subColor =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Repas du jour',
          style: AppTextStyles.headlineSmall.copyWith(
            color: textColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          DateFormat('d MMMM', 'fr_FR').format(date),
          style: AppTextStyles.caption.copyWith(color: subColor),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// État vide
// ---------------------------------------------------------------------------

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subColor =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final iconBg = isDark ? AppColors.darkSurface2 : AppColors.lightSurface2;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 52),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(shape: BoxShape.circle, color: iconBg),
            child: Icon(
              Icons.restaurant_outlined,
              color: subColor,
              size: 28,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Aucun repas enregistré',
            style: AppTextStyles.headlineSmall.copyWith(color: textColor),
          ),
          const SizedBox(height: 8),
          Text(
            'Appuyez sur + pour ajouter\nun repas ou une photo.',
            style: AppTextStyles.bodySmall.copyWith(color: subColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms);
  }
}

// ---------------------------------------------------------------------------
// Carte repas — Clean, moderne
// ---------------------------------------------------------------------------

class _MealCard extends StatelessWidget {
  const _MealCard({required this.entry, required this.isDark});
  final dynamic entry;
  final bool isDark;

  String _mealEmoji(String summary) {
    final s = summary.toLowerCase();
    if (s.contains('poulet') || s.contains('chicken')) return '🍗';
    if (s.contains('poisson') || s.contains('saumon') || s.contains('thon')) {
      return '🐟';
    }
    if (s.contains('boeuf') || s.contains('steak') || s.contains('viande')) {
      return '🥩';
    }
    if (s.contains('salade')) return '🥗';
    if (s.contains('pâte') || s.contains('pasta') || s.contains('riz')) {
      return '🍝';
    }
    if (s.contains('pizza')) return '🍕';
    if (s.contains('burger') || s.contains('sandwich')) return '🍔';
    if (s.contains('fruit') || s.contains('pomme') || s.contains('banane')) {
      return '🍎';
    }
    if (s.contains('yaourt') || s.contains('fromage') || s.contains('lait')) {
      return '🧀';
    }
    if (s.contains('oeuf') || s.contains('omelette')) return '🥚';
    if (s.contains('soupe')) return '🍲';
    if (s.contains('café') || s.contains('thé')) return '☕';
    if (s.contains('pain') || s.contains('toast')) return '🍞';
    if (s.contains('légume') ||
        s.contains('brocoli') ||
        s.contains('carotte')) { return '🥦'; }
    return '🍽️';
  }

  @override
  Widget build(BuildContext context) {
    final time = DateFormat('HH:mm').format(entry.loggedAt as DateTime);
    final emoji = _mealEmoji(entry.aiSummary as String);
    final cardBg = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subColor =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final emojiBg = isDark ? AppColors.darkSurface2 : AppColors.lightSurface2;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(AppRadius.cardSmall),
        border: Border.all(color: border),
        boxShadow: isDark ? [] : AppShadows.soft,
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.icon),
              color: emojiBg,
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.aiSummary as String,
                  style: AppTextStyles.labelMedium.copyWith(color: textColor),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: AppTextStyles.caption.copyWith(color: subColor),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${entry.calories}',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'kcal',
                style: AppTextStyles.caption.copyWith(color: subColor),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn().slideX(begin: 0.03);
  }
}

// ---------------------------------------------------------------------------
// FAB Ajouter — accent indigo, moderne
// ---------------------------------------------------------------------------

class _AddFAB extends StatelessWidget {
  const _AddFAB({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: BorderRadius.circular(AppRadius.button),
          boxShadow: AppShadows.accentButton,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add_rounded, color: AppColors.white, size: 22),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Ajouter',
              style: AppTextStyles.buttonSmall.copyWith(color: AppColors.white),
            ),
          ],
        ),
      ),
    );
  }
}
