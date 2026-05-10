import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../core/utils/providers.dart';

/// Page d'onboarding — 3 slides + CTA vers la configuration du profil.
class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final _controller = PageController();
  int _currentPage = 0;

  static const _slides = [
    _OnboardingSlide(
      emoji: '🥗',
      title: 'Mangez\nconsciemment.',
      subtitle:
          'Décrivez votre repas en quelques mots. L\'IA calcule les calories et les macros en secondes.',
      gradient: [Color(0xFF4CAF82), Color(0xFF2E7D52)],
    ),
    _OnboardingSlide(
      emoji: '🎙️',
      title: 'Parlez,\npas de saisie.',
      subtitle:
          'Utilisez votre voix pour logger ce que vous mangez. Aussi simple que d\'envoyer un message vocal.',
      gradient: [Color(0xFF5C6BC0), Color(0xFF3949AB)],
    ),
    _OnboardingSlide(
      emoji: '🔐',
      title: 'Vos données,\nvos règles.',
      subtitle:
          'Toutes vos données restent sur votre téléphone. Vos clés API, vos informations — jamais partagés.',
      gradient: [Color(0xFFEF5350), Color(0xFFC62828)],
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: _slides.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (context, index) =>
                _SlideView(slide: _slides[index]),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.horizontalPadding,
              ),
              child: Column(
                children: [
                  // Skip
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: TextButton(
                        onPressed: _finish,
                        child: Text(
                          'Passer',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 300.ms),

                  const Spacer(),

                  // Indicateurs de page
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _slides.length,
                      (i) => AnimatedContainer(
                        duration: AppConstants.animationFast,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: i == _currentPage ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: i == _currentPage
                              ? AppColors.white
                              : AppColors.white.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Bouton principal
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _onNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.white,
                        foregroundColor:
                            _slides[_currentPage].gradient.first,
                        minimumSize: const Size.fromHeight(56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        _currentPage == _slides.length - 1
                            ? 'Commencer'
                            : 'Suivant',
                        style: AppTextStyles.button.copyWith(
                          color: _slides[_currentPage].gradient.first,
                        ),
                      ),
                    ),
                  ).animate().slideY(
                        begin: 0.3,
                        delay: 400.ms,
                        curve: Curves.easeOutCubic,
                      ),

                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onNext() {
    if (_currentPage < _slides.length - 1) {
      _controller.nextPage(
        duration: AppConstants.animationMedium,
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    await ref
        .read(preferencesServiceProvider)
        .setOnboardingCompleted(true);
    if (mounted) {
      context.go(AppRoutes.setup);
    }
  }
}

// ---------------------------------------------------------------------------
// Slide
// ---------------------------------------------------------------------------

class _OnboardingSlide {
  const _OnboardingSlide({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.gradient,
  });

  final String emoji;
  final String title;
  final String subtitle;
  final List<Color> gradient;
}

class _SlideView extends StatelessWidget {
  const _SlideView({required this.slide});
  final _OnboardingSlide slide;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: slide.gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 80,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              Text(
                slide.emoji,
                style: const TextStyle(fontSize: 72),
              )
                  .animate()
                  .scale(delay: 100.ms, curve: Curves.elasticOut)
                  .fadeIn(),
              const SizedBox(height: 32),
              Text(
                slide.title,
                style: AppTextStyles.displayMedium.copyWith(
                  color: AppColors.white,
                  height: 1.1,
                ),
              )
                  .animate()
                  .slideX(begin: -0.2, delay: 200.ms)
                  .fadeIn(delay: 200.ms),
              const SizedBox(height: 20),
              Text(
                slide.subtitle,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.white.withValues(alpha: 0.85),
                  height: 1.6,
                ),
              )
                  .animate()
                  .slideX(begin: -0.2, delay: 350.ms)
                  .fadeIn(delay: 350.ms),
            ],
          ),
        ),
      ),
    );
  }
}
