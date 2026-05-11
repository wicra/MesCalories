import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../tracking/presentation/providers/tracking_provider.dart';
import '../../../tracking/domain/entities/meal_entry.dart';

/// Page de visualisation des données nutritionnelles.
class DataPage extends ConsumerWidget {
  const DataPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final daysAsync = ref.watch(daysWithDataProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            title: Text('Mes données', style: AppTextStyles.headlineMedium),
            leading: BackButton(
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          daysAsync.when(
            loading: () => const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(color: AppColors.accent),
              ),
            ),
            error: (e, _) => SliverFillRemaining(
              child: Center(child: Text('$e')),
            ),
            data: (days) {
              if (days.isEmpty) {
                return SliverFillRemaining(
                  child: _EmptyDataState(isDark: isDark),
                );
              }
              return _DataBody(days: days, isDark: isDark);
            },
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _DataBody extends ConsumerWidget {
  const _DataBody({required this.days, required this.isDark});
  final List<DateTime> days;
  final bool isDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Récupère les 30 dernières journées max
    final recentDays = days.take(30).toList();

    return SliverPadding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.pagePadding, vertical: AppSpacing.md),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          _GlobalStatsCard(days: recentDays, isDark: isDark),
          const SizedBox(height: AppSpacing.md),
          _WeeklyCaloriesChart(days: recentDays, isDark: isDark),
          const SizedBox(height: AppSpacing.md),
          _SectionLabel(label: 'Détail par journée', isDark: isDark),
          const SizedBox(height: AppSpacing.sm),
          ...recentDays.asMap().entries.map((e) => _DayStatRow(
                date: e.value,
                isDark: isDark,
                animDelay: e.key * 40,
              )),
          const SizedBox(height: 80),
        ]),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Carte stats globales
// ---------------------------------------------------------------------------

class _GlobalStatsCard extends ConsumerWidget {
  const _GlobalStatsCard({required this.days, required this.isDark});
  final List<DateTime> days;
  final bool isDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Agrège les résumés des jours disponibles
    final summaries = days
        .map((d) => ref.watch(dailySummaryProvider(d)).valueOrNull)
        .whereType<DailySummary>();

    if (summaries.isEmpty) return const SizedBox.shrink();

    int totalCal = 0;
    double totalP = 0, totalC = 0, totalF = 0;
    int mealCount = 0;
    for (final s in summaries) {
      totalCal += s.totalCalories;
      totalP += s.totalProteinsG;
      totalC += s.totalCarbsG;
      totalF += s.totalFatsG;
      mealCount += s.entries.length;
    }
    final n = summaries.length;
    final avgCal = n > 0 ? (totalCal / n).round() : 0;

    final cardBg = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subColor =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: border),
        boxShadow: isDark ? [] : AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vue d\'ensemble · ${days.length} jours',
            style: AppTextStyles.labelMedium.copyWith(color: subColor),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatCell(
                  label: 'Moy. calories',
                  value: '$avgCal',
                  unit: 'kcal/j',
                  color: AppColors.calories,
                  isDark: isDark),
              _StatCell(
                  label: 'Repas logués',
                  value: '$mealCount',
                  unit: 'total',
                  color: AppColors.accent,
                  isDark: isDark),
              _StatCell(
                  label: 'Jours suivis',
                  value: '${days.length}',
                  unit: 'jours',
                  color: AppColors.success,
                  isDark: isDark),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _MacroAvgRow(
            avgP: n > 0 ? totalP / n : 0,
            avgC: n > 0 ? totalC / n : 0,
            avgF: n > 0 ? totalF / n : 0,
            textColor: textColor,
            subColor: subColor,
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.04);
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
    required this.isDark,
  });
  final String label, value, unit;
  final Color color;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final sub = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    return Column(
      children: [
        Text(value,
            style: AppTextStyles.numeralSmall
                .copyWith(color: color, fontWeight: FontWeight.w700)),
        Text(unit, style: AppTextStyles.caption.copyWith(color: sub)),
        const SizedBox(height: 2),
        Text(label,
            style: AppTextStyles.caption.copyWith(
                color: sub, fontSize: 10)),
      ],
    );
  }
}

class _MacroAvgRow extends StatelessWidget {
  const _MacroAvgRow({
    required this.avgP,
    required this.avgC,
    required this.avgF,
    required this.textColor,
    required this.subColor,
  });
  final double avgP, avgC, avgF;
  final Color textColor, subColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _MacroAvgItem(label: 'Prot.', value: avgP, color: AppColors.proteins, sub: subColor),
        _MacroAvgItem(label: 'Gluc.', value: avgC, color: AppColors.carbs, sub: subColor),
        _MacroAvgItem(label: 'Lip.', value: avgF, color: AppColors.fats, sub: subColor),
      ],
    );
  }
}

class _MacroAvgItem extends StatelessWidget {
  const _MacroAvgItem(
      {required this.label,
      required this.value,
      required this.color,
      required this.sub});
  final String label;
  final double value;
  final Color color, sub;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
        const SizedBox(width: 6),
        Text('${value.toStringAsFixed(0)}g/j',
            style: AppTextStyles.caption.copyWith(color: sub)),
        const SizedBox(width: 4),
        Text(label,
            style: AppTextStyles.caption
                .copyWith(color: sub, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Graphique calories 7 derniers jours
// ---------------------------------------------------------------------------

class _WeeklyCaloriesChart extends ConsumerWidget {
  const _WeeklyCaloriesChart({required this.days, required this.isDark});
  final List<DateTime> days;
  final bool isDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final last7 = days.take(7).toList().reversed.toList();
    final summaries = last7
        .map((d) => ref.watch(dailySummaryProvider(d)).valueOrNull)
        .toList();

    final maxCal = summaries
        .whereType<DailySummary>()
        .map((s) => s.totalCalories)
        .fold(0, (a, b) => a > b ? a : b);

    final cardBg = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final subColor =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: border),
        boxShadow: isDark ? [] : AppShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '7 derniers jours',
            style:
                AppTextStyles.labelMedium.copyWith(color: subColor),
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            height: 80,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: last7.asMap().entries.map((e) {
                final summary = summaries[e.key];
                final cal = summary?.totalCalories ?? 0;
                final ratio = maxCal > 0 ? cal / maxCal : 0.0;
                final day = DateFormat('E', 'fr_FR').format(e.value);
                return _CalBar(
                  label: day,
                  ratio: ratio.toDouble(),
                  calories: cal,
                  isDark: isDark,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms);
  }
}

class _CalBar extends StatelessWidget {
  const _CalBar({
    required this.label,
    required this.ratio,
    required this.calories,
    required this.isDark,
  });
  final String label;
  final double ratio;
  final int calories;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final sub = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final barColor = calories == 0 ? (isDark ? AppColors.darkSurface3 : AppColors.lightSurface3) : AppColors.accent;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (calories > 0)
          Text(
            '$calories',
            style: AppTextStyles.caption.copyWith(
                color: AppColors.accent, fontSize: 9),
          ),
        const SizedBox(height: 2),
        AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutCubic,
          width: 28,
          height: (60 * ratio).clamp(4.0, 60.0),
          decoration: BoxDecoration(
            color: barColor,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 4),
        Text(label,
            style: AppTextStyles.caption.copyWith(color: sub, fontSize: 10)),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Ligne détail par jour
// ---------------------------------------------------------------------------

class _DayStatRow extends ConsumerWidget {
  const _DayStatRow(
      {required this.date, required this.isDark, required this.animDelay});
  final DateTime date;
  final bool isDark;
  final int animDelay;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(dailySummaryProvider(date));
    return summaryAsync.when(
      loading: () => const SizedBox(height: 56),
      error: (_, __) => const SizedBox.shrink(),
      data: (summary) {
        final cardBg = isDark ? AppColors.darkSurface : AppColors.lightSurface;
        final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
        final textColor = isDark ? AppColors.darkText : AppColors.lightText;
        final subColor =
            isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
        final progress =
            (summary.totalCalories / summary.calorieGoal).clamp(0.0, 1.0);
        final barColor = progress >= 1.0
            ? AppColors.error
            : progress > 0.85
                ? AppColors.warning
                : AppColors.accent;

        final isToday = _isToday(date);

        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(AppRadius.cardSmall),
            border: Border.all(
                color: isToday ? AppColors.accent.withValues(alpha: 0.4) : border,
                width: isToday ? 1.5 : 1),
            boxShadow: isDark ? [] : AppShadows.soft,
          ),
          child: Row(
            children: [
              SizedBox(
                width: 90,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isToday
                          ? "Aujourd'hui"
                          : DateFormat('EEE d MMM', 'fr_FR').format(date),
                      style: AppTextStyles.labelMedium.copyWith(
                          color: isToday ? AppColors.accent : textColor,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${summary.entries.length} repas',
                      style: AppTextStyles.caption.copyWith(color: subColor),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: isDark
                            ? AppColors.darkSurface3
                            : AppColors.lightSurface3,
                        valueColor: AlwaysStoppedAnimation(barColor),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${summary.totalCalories}',
                    style: AppTextStyles.labelMedium.copyWith(
                        color: barColor, fontWeight: FontWeight.w700),
                  ),
                  Text('kcal',
                      style: AppTextStyles.caption.copyWith(color: subColor)),
                ],
              ),
            ],
          ),
        ).animate().fadeIn(delay: Duration(milliseconds: animDelay));
      },
    );
  }

  bool _isToday(DateTime d) {
    final now = DateTime.now();
    return d.year == now.year && d.month == now.month && d.day == now.day;
  }
}

// ---------------------------------------------------------------------------

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, required this.isDark});
  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: AppTextStyles.labelSmall.copyWith(
        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _EmptyDataState extends StatelessWidget {
  const _EmptyDataState({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final sub = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.bar_chart_rounded,
              size: 64,
              color: isDark ? AppColors.darkSurface3 : AppColors.lightSurface3),
          const SizedBox(height: 16),
          Text('Aucune donnée', style: AppTextStyles.headlineSmall.copyWith(color: text)),
          const SizedBox(height: 8),
          Text('Commencez à loguer vos repas\npour voir vos stats ici.',
              style: AppTextStyles.bodySmall.copyWith(color: sub),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
