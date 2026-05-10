import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../tracking/presentation/providers/tracking_provider.dart';
import '../../../tracking/domain/entities/meal_entry.dart';

/// Page historique — liste des journées avec données.
class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final daysAsync = ref.watch(daysWithDataProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            title: Text('Historique', style: AppTextStyles.headlineMedium),
          ),
          daysAsync.when(
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
            data: (days) {
              if (days.isEmpty) {
                return SliverFillRemaining(child: _EmptyHistoryState());
              }
              return SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.horizontalPadding,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _DayCard(
                      date: days[index],
                      animationDelay: index * 50,
                    ),
                    childCount: days.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DayCard extends ConsumerWidget {
  const _DayCard({required this.date, required this.animationDelay});
  final DateTime date;
  final int animationDelay;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(dailySummaryProvider(date));
    final isToday = _isToday(date);

    return summaryAsync.when(
      loading: () => const SizedBox(height: 80),
      error: (_, __) => const SizedBox.shrink(),
      data: (summary) => GestureDetector(
        onTap: () => _showDayDetail(context, date, summary),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isToday
                ? AppColors.accent.withValues(alpha: 0.08)
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
            border: isToday
                ? Border.all(color: AppColors.accent, width: 1.5)
                : null,
          ),
          child: Row(
            children: [
              // Date
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('d', 'fr_FR').format(date),
                    style: AppTextStyles.numeralSmall.copyWith(
                      color: isToday ? AppColors.accent : null,
                    ),
                  ),
                  Text(
                    DateFormat('MMM', 'fr_FR').format(date),
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.grey500,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              const VerticalDivider(width: 1),
              const SizedBox(width: 16),
              // Résumé
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isToday
                              ? "Aujourd'hui"
                              : DateFormat('EEEE', 'fr_FR').format(date),
                          style: AppTextStyles.labelLarge.copyWith(
                            color: isToday ? AppColors.accent : null,
                          ),
                        ),
                        Text(
                          '${summary.totalCalories} kcal',
                          style: AppTextStyles.headlineSmall.copyWith(
                            color: AppColors.accent,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    LinearProgressIndicator(
                      value: summary.calorieProgress,
                      backgroundColor: AppColors.grey200,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        summary.calorieProgress >= 1.0
                            ? AppColors.error
                            : AppColors.accent,
                      ),
                      minHeight: 4,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${summary.entries.length} repas · P: ${summary.totalProteinsG.toStringAsFixed(0)}g · G: ${summary.totalCarbsG.toStringAsFixed(0)}g · L: ${summary.totalFatsG.toStringAsFixed(0)}g',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.grey400,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.grey400,
              ),
            ],
          ),
        ).animate().fadeIn(delay: Duration(milliseconds: animationDelay)),
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  void _showDayDetail(
      BuildContext context, DateTime date, DailySummary summary) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _DayDetailSheet(date: date, summary: summary),
    );
  }
}

class _DayDetailSheet extends StatelessWidget {
  const _DayDetailSheet({required this.date, required this.summary});
  final DateTime date;
  final DailySummary summary;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.95,
      minChildSize: 0.4,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('EEEE d MMMM', 'fr_FR').format(date),
                      style: AppTextStyles.headlineMedium,
                    ),
                    Text(
                      '${summary.totalCalories} kcal',
                      style: AppTextStyles.headlineMedium.copyWith(
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.horizontalPadding,
                  ),
                  itemCount: summary.entries.length,
                  itemBuilder: (context, i) {
                    final entry = summary.entries[i];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    entry.aiSummary,
                                    style: AppTextStyles.labelLarge,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    DateFormat('HH:mm').format(entry.loggedAt),
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.grey400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${entry.calories} kcal',
                              style: AppTextStyles.headlineSmall.copyWith(
                                color: AppColors.accent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _EmptyHistoryState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('📅', style: TextStyle(fontSize: 60)),
          const SizedBox(height: 20),
          Text('Aucun historique', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 8),
          Text(
            'Vos journées apparaîtront ici\naprès le premier enregistrement.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.grey500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
