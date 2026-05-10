import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../providers/tracking_provider.dart';
import '../../domain/entities/nutrition_analysis.dart';

/// Page principale de saisie alimentaire.
/// Supporte : texte libre, voix, photo.
class TrackingPage extends ConsumerStatefulWidget {
  const TrackingPage({super.key});

  @override
  ConsumerState<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends ConsumerState<TrackingPage> {
  final _textController = TextEditingController();
  final _speechToText = SpeechToText();
  bool _sttAvailable = false;
  bool _isListening = false;
  String _mode = 'text';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    _sttAvailable = await _speechToText.initialize(
      onError: (_) => setState(() => _isListening = false),
    );
    setState(() {});
  }

  @override
  void dispose() {
    _textController.dispose();
    _speechToText.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final trackingState = ref.watch(trackingNotifierProvider);

    return Scaffold(
      body: SafeArea(
        child: trackingState.valueOrNull is TrackingSuccess
            ? _ResultView(
                analysis: (trackingState.valueOrNull as TrackingSuccess).analysis,
                userInput: _textController.text,
                inputMode: _mode,
                onConfirm: _saveEntry,
                onDiscard: () {
                  ref.read(trackingNotifierProvider.notifier).reset();
                  _textController.clear();
                },
              )
            : _InputView(
                textController: _textController,
                isLoading: trackingState.valueOrNull is TrackingLoading,
                isListening: _isListening,
                sttAvailable: _sttAvailable,
                error: trackingState.valueOrNull is TrackingError
                    ? (trackingState.valueOrNull as TrackingError).message
                    : null,
                onSubmit: _analyzeText,
                onVoiceStart: _startListening,
                onVoiceStop: _stopListening,
                onPhotoSelect: _selectPhoto,
              ),
      ),
    );
  }

  Future<void> _analyzeText() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    setState(() => _mode = 'text');
    await ref.read(trackingNotifierProvider.notifier).analyzeText(text);
  }

  Future<void> _startListening() async {
    if (!_sttAvailable) return;
    setState(() => _isListening = true);
    _textController.clear();

    await _speechToText.listen(
      onResult: (result) {
        _textController.text = result.recognizedWords;
        if (result.finalResult) {
          setState(() => _isListening = false);
        }
      },
      localeId: 'fr_FR',
      pauseFor: const Duration(seconds: 3),
    );
  }

  Future<void> _stopListening() async {
    await _speechToText.stop();
    setState(() => _isListening = false);
    if (_textController.text.isNotEmpty) {
      setState(() => _mode = 'voice');
      await ref
          .read(trackingNotifierProvider.notifier)
          .analyzeText(_textController.text);
    }
  }

  Future<void> _selectPhoto() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (image == null) return;
    setState(() => _mode = 'photo');
    final text = _textController.text.trim().isEmpty
        ? 'Analyse ce repas sur la photo.'
        : _textController.text.trim();

    await ref.read(trackingNotifierProvider.notifier).analyzeText(text);
  }

  Future<void> _saveEntry(NutritionAnalysis analysis) async {
    final saved = await ref.read(trackingNotifierProvider.notifier).saveEntry(
          userInput: _textController.text.trim(),
          analysis: analysis,
          inputMode: _mode,
        );
    if (saved && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Repas enregistré !')),
      );
      _textController.clear();
    }
  }
}

// ---------------------------------------------------------------------------
// Panneau de saisie
// ---------------------------------------------------------------------------

class _InputView extends StatelessWidget {
  const _InputView({
    required this.textController,
    required this.isLoading,
    required this.isListening,
    required this.sttAvailable,
    required this.onSubmit,
    required this.onVoiceStart,
    required this.onVoiceStop,
    required this.onPhotoSelect,
    this.error,
  });

  final TextEditingController textController;
  final bool isLoading;
  final bool isListening;
  final bool sttAvailable;
  final String? error;
  final VoidCallback onSubmit;
  final VoidCallback onVoiceStart;
  final VoidCallback onVoiceStop;
  final VoidCallback onPhotoSelect;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text('Qu\'avez-vous mangé ?', style: AppTextStyles.displaySmall)
              .animate()
              .fadeIn(),
          const SizedBox(height: 6),
          Text(
            'Décrivez votre repas naturellement — l\'IA fait le reste.',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey500),
          ).animate().fadeIn(delay: 100.ms),
          const SizedBox(height: 24),

          // Zone de texte
          TextField(
            controller: textController,
            maxLines: 6,
            minLines: 4,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              hintText:
                  'Ex : Ce matin j\'ai mangé 2 œufs brouillés, une tartine avec du beurre et un café avec du lait...',
            ),
          ).animate().fadeIn(delay: 150.ms),

          const SizedBox(height: 16),

          if (error != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.09),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                error!,
                style:
                    AppTextStyles.bodySmall.copyWith(color: AppColors.error),
              ),
            ).animate().shakeX(),

          // Boutons d'action
          Row(
            children: [
              // Bouton voix
              if (sttAvailable)
                _ActionButton(
                  onTap: isListening ? onVoiceStop : onVoiceStart,
                  icon: isListening
                      ? Icons.stop_circle_rounded
                      : Icons.mic_rounded,
                  label: isListening ? 'Arrêter' : 'Voix',
                  color: isListening ? AppColors.error : AppColors.info,
                  isAnimated: isListening,
                ),
              const SizedBox(width: 10),
              // Bouton photo
              _ActionButton(
                onTap: onPhotoSelect,
                icon: Icons.camera_alt_rounded,
                label: 'Photo',
                color: AppColors.warning,
              ),
              const Spacer(),
              // Bouton analyser
              ElevatedButton.icon(
                onPressed: isLoading ? null : onSubmit,
                icon: isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.white,
                        ),
                      )
                    : const Icon(Icons.auto_awesome_rounded, size: 20),
                label: const Text('Analyser'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(140, 52),
                ),
              ),
            ],
          ).animate().fadeIn(delay: 250.ms),

          if (isListening) ...[
            const SizedBox(height: 24),
            Center(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.mic_rounded,
                      color: AppColors.error,
                      size: 36,
                    ),
                  )
                      .animate(onPlay: (c) => c.repeat())
                      .scale(
                        begin: const Offset(1, 1),
                        end: const Offset(1.15, 1.15),
                        duration: 800.ms,
                        curve: Curves.easeInOut,
                      )
                      .then()
                      .scale(
                        begin: const Offset(1.15, 1.15),
                        end: const Offset(1, 1),
                        duration: 800.ms,
                        curve: Curves.easeInOut,
                      ),
                  const SizedBox(height: 12),
                  Text(
                    'Je vous écoute...',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.grey500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.onTap,
    required this.icon,
    required this.label,
    required this.color,
    this.isAnimated = false,
  });

  final VoidCallback onTap;
  final IconData icon;
  final String label;
  final Color color;
  final bool isAnimated;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.labelMedium.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Panneau de résultats IA
// ---------------------------------------------------------------------------

class _ResultView extends StatelessWidget {
  const _ResultView({
    required this.analysis,
    required this.userInput,
    required this.inputMode,
    required this.onConfirm,
    required this.onDiscard,
  });

  final NutritionAnalysis analysis;
  final String userInput;
  final String inputMode;
  final ValueChanged<NutritionAnalysis> onConfirm;
  final VoidCallback onDiscard;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('✨', style: TextStyle(fontSize: 28)),
              const SizedBox(width: 10),
              Text('Analyse IA', style: AppTextStyles.displaySmall),
            ],
          ).animate().fadeIn(),
          const SizedBox(height: 8),
          Text(
            analysis.summary,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.grey500,
            ),
          ).animate().fadeIn(delay: 100.ms),
          const SizedBox(height: 24),

          // Calories totales
          _BigCalorieCard(calories: analysis.calories)
              .animate()
              .scale(delay: 150.ms, curve: Curves.elasticOut),

          const SizedBox(height: 16),

          // Macros
          _MacrosGrid(analysis: analysis).animate().fadeIn(delay: 200.ms),

          const SizedBox(height: 24),

          // Aliments détectés
          if (analysis.detectedFoods.isNotEmpty) ...[
            Text('Aliments détectés', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 12),
            ...analysis.detectedFoods.asMap().entries.map(
                  (e) => _FoodItemRow(food: e.value)
                      .animate()
                      .fadeIn(delay: Duration(milliseconds: 250 + e.key * 50)),
                ),
            const SizedBox(height: 24),
          ],

          // Boutons de confirmation
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onDiscard,
                  child: const Text('Modifier'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: () => onConfirm(analysis),
                  icon: const Icon(Icons.check_rounded),
                  label: const Text('Enregistrer'),
                ),
              ),
            ],
          ).animate().fadeIn(delay: 400.ms),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _BigCalorieCard extends StatelessWidget {
  const _BigCalorieCard({required this.calories});
  final int calories;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.accent, AppColors.accentLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Calories estimées',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.white.withValues(alpha: 0.8),
            ),
          ),
          Text(
            '$calories kcal',
            style: AppTextStyles.numeralLarge.copyWith(
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _MacrosGrid extends StatelessWidget {
  const _MacrosGrid({required this.analysis});
  final NutritionAnalysis analysis;

  @override
  Widget build(BuildContext context) {
    final macros = [
      ('Protéines', '${analysis.proteinsG.toStringAsFixed(1)}g', AppColors.proteins),
      ('Glucides', '${analysis.carbsG.toStringAsFixed(1)}g', AppColors.carbs),
      ('Lipides', '${analysis.fatsG.toStringAsFixed(1)}g', AppColors.fats),
      ('Fibres', '${analysis.fibersG.toStringAsFixed(1)}g', AppColors.info),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2.2,
      physics: const NeverScrollableScrollPhysics(),
      children: macros.map((m) {
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: m.$3.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                m.$2,
                style: AppTextStyles.headlineMedium.copyWith(color: m.$3),
              ),
              Text(
                m.$1,
                style: AppTextStyles.caption.copyWith(color: AppColors.grey500),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _FoodItemRow extends StatelessWidget {
  const _FoodItemRow({required this.food});
  final DetectedFood food;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(food.name, style: AppTextStyles.labelLarge),
                Text(
                  food.portion,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.grey400,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${food.calories} kcal',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.accent,
            ),
          ),
        ],
      ),
    );
  }
}
