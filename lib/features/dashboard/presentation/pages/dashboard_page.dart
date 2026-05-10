import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../tracking/presentation/providers/tracking_provider.dart';
import '../../../auth/presentation/providers/profile_provider.dart';

/// Page principale — tableau de bord journalier.
class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = DateTime.now();
    final summaryAsync = ref.watch(dailySummaryProvider(today));
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, profileAsync),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.horizontalPadding,
            ),
            sliver: summaryAsync.when(
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
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
              data: (summary) => SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 8),
                  _CalorieRingCard(summary: summary),
                  const SizedBox(height: 16),
                  _MacrosRow(summary: summary),
                  const SizedBox(height: 24),
                  _SectionTitle(title: 'Aujourd\'hui', date: today),
                  const SizedBox(height: 12),
                  if (summary.entries.isEmpty)
                    _EmptyState()
                  else
                    ...summary.entries.map(
                      (e) => _MealCard(entry: e),
                    ),
                  const SizedBox(height: 100),
                ]),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go(AppRoutes.tracking),
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.white,
        elevation: 0,
        icon: const Icon(Icons.add_rounded),
        label: Text('Ajouter un repas', style: AppTextStyles.buttonSmall),
      ),
    );
  }

  SliverAppBar _buildAppBar(
    BuildContext context,
    AsyncValue profileAsync,
  ) {
    final greeting = _getGreeting();
    final firstName = profileAsync.valueOrNull?.firstName ?? '';

    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('EEEE d MMMM', 'fr_FR').format(DateTime.now()),
            style: AppTextStyles.caption.copyWith(color: AppColors.grey500),
          ),
          Text(
            firstName.isNotEmpty ? '$greeting, $firstName 👋' : greeting,
            style: AppTextStyles.headlineMedium,
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.person_outline_rounded),
          onPressed: () => context.go(AppRoutes.settings),
        ),
      ],
    );
  }

  String _getGreeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Bonjour';
    if (h < 18) return 'Bon après-midi';
    return 'Bonsoir';
  }
}

// ---------------------------------------------------------------------------
// Widgets du Dashboard
// ---------------------------------------------------------------------------

class _CalorieRingCard extends StatelessWidget {
  const _CalorieRingCard({required this.summary});
  final dynamic summary;

  @override
  Widget build(BuildContext context) {
    final progress = summary.calorieProgress as double;
    final total = summary.totalCalories as int;
    final goal = summary.calorieGoal as int;
    final remaining = summary.remainingCalories as int;

    final color = progress >= 1.0
        ? AppColors.error
        : progress > 0.85
            ? AppColors.warning
            : AppColors.accent;

    return Container(
      padding: const EdgeInsets.all(AppConstants.cardPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            height: 120,
            child: CustomPaint(
              painter: _RingPainter(progress: progress, color: color),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$total',
                      style: AppTextStyles.numeralMedium.copyWith(
                        color: color,
                      ),
                    ),
                    Text(
                      'kcal',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.grey500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
              .animate()
              .scale(delay: 100.ms, curve: Curves.elasticOut),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Objectif',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.grey500,
                  ),
                ),
                Text(
                  '$goal kcal',
                  style: AppTextStyles.headlineMedium,
                ),
                const SizedBox(height: 12),
                Text(
                  remaining > 0
                      ? '$remaining kcal restantes'
                      : '${(-remaining)} kcal dépassées',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: remaining > 0 ? AppColors.success : AppColors.error,
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.grey200,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(3),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 50.ms).slideY(begin: 0.1);
  }
}

class _MacrosRow extends StatelessWidget {
  const _MacrosRow({required this.summary});
  final dynamic summary;

  @override
  Widget build(BuildContext context) {
    final macros = [
      ('P', summary.totalProteinsG, summary.proteinGoalG, AppColors.proteins),
      ('G', summary.totalCarbsG, summary.carbGoalG, AppColors.carbs),
      ('L', summary.totalFatsG, summary.fatGoalG, AppColors.fats),
    ];

    return Row(
      children: macros
          .asMap()
          .entries
          .map(
            (e) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: e.key == 0 ? 0 : 6,
                  right: e.key == 2 ? 0 : 6,
                ),
                child: _MacroCard(
                  label: e.value.$1,
                  current: e.value.$2,
                  goal: e.value.$3.toDouble(),
                  color: e.value.$4,
                ),
              ),
            ),
          )
          .toList(),
    ).animate().fadeIn(delay: 200.ms);
  }
}

class _MacroCard extends StatelessWidget {
  const _MacroCard({
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

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(color: color),
          ),
          const SizedBox(height: 4),
          Text(
            '${current.toStringAsFixed(0)}g',
            style: AppTextStyles.headlineMedium.copyWith(color: color),
          ),
          Text(
            '/ ${goal.toStringAsFixed(0)}g',
            style: AppTextStyles.caption.copyWith(color: AppColors.grey400),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: color.withValues(alpha: 0.15),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 4,
            borderRadius: BorderRadius.circular(2),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.date});
  final String title;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.headlineMedium),
        Text(
          DateFormat('d MMM', 'fr_FR').format(date),
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey400),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Column(
        children: [
          const Text('🍽️', style: TextStyle(fontSize: 52)),
          const SizedBox(height: 16),
          Text(
            'Aucun repas enregistré',
            style: AppTextStyles.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Appuyez sur "Ajouter un repas" pour commencer\nà suivre vos calories.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.grey500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms);
  }
}

class _MealCard extends StatelessWidget {
  const _MealCard({required this.entry});
  final dynamic entry;

  @override
  Widget build(BuildContext context) {
    final time = DateFormat('HH:mm').format(entry.loggedAt as DateTime);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.restaurant_rounded,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.aiSummary as String,
                  style: AppTextStyles.labelLarge,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.grey400,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${entry.calories} kcal',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.accent,
                ),
              ),
              Text(
                'P: ${(entry.proteinsG as double).toStringAsFixed(0)}g',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.grey400,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn().slideX(begin: 0.05);
  }
}

// ---------------------------------------------------------------------------
// Peintre pour l'anneau de progression
// ---------------------------------------------------------------------------

class _RingPainter extends CustomPainter {
  _RingPainter({required this.progress, required this.color});
  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 12) / 2;
    const strokeWidth = 10.0;

    final bgPaint = Paint()
      ..color = AppColors.grey200
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final fgPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    final sweepAngle = 2 * 3.14159 * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2,
      sweepAngle,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}
