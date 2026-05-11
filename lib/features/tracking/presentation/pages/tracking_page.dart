import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../providers/tracking_provider.dart';
import '../../domain/entities/nutrition_analysis.dart';

/// Page principale de saisie alimentaire. Style Liquid Glass premium.
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
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: trackingState.valueOrNull is TrackingSuccess
            ? _ResultView(
                analysis:
                    (trackingState.valueOrNull as TrackingSuccess).analysis,
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
                onBarcodeSelect: _openBarcodeScanner,
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

  Future<void> _openBarcodeScanner() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _BarcodeScannerSheet(),
    );
    if (result != null && result.isNotEmpty) {
      _textController.text = result;
      setState(() => _mode = 'barcode');
      await ref.read(trackingNotifierProvider.notifier).analyzeText(result);
    }
  }

  Future<void> _saveEntry(NutritionAnalysis analysis) async {
    final saved = await ref.read(trackingNotifierProvider.notifier).saveEntry(
          userInput: _textController.text.trim(),
          analysis: analysis,
          inputMode: _mode,
        );
    if (saved && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Repas enregistré',
            style: AppTextStyles.labelMedium.copyWith(color: AppColors.white),
          ),
          backgroundColor: AppColors.surfaceTertiaryDark,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );
      _textController.clear();
    }
  }
}

// ---------------------------------------------------------------------------
// Panneau de saisie — Liquid Glass
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
    required this.onBarcodeSelect,
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
  final VoidCallback onBarcodeSelect;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Text(
            'Qu\'avez-vous mangé ?',
            style: AppTextStyles.displaySmall.copyWith(color: AppColors.white),
          ).animate().fadeIn(),
          const SizedBox(height: 6),
          Text(
            'Décrivez votre repas — l\'IA fait le reste.',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ).animate().fadeIn(delay: 80.ms),
          const SizedBox(height: 24),

          // Zone de texte glass
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: TextField(
                controller: textController,
                maxLines: 6,
                minLines: 5,
                textCapitalization: TextCapitalization.sentences,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.white,
                ),
                decoration: InputDecoration(
                  hintText:
                      '2 œufs, une tartine de beurre et un café au lait...',
                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textTertiary,
                  ),
                  fillColor: AppColors.glassWhite,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(
                      color: AppColors.glassBorder,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(
                      color: AppColors.glassBorder,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(
                      color: AppColors.accent,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ).animate().fadeIn(delay: 120.ms),

          const SizedBox(height: 16),

          if (error != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.error.withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  error!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ),
            ).animate().shakeX(),

          // Actions
          Row(
            children: [
              if (sttAvailable) ...[
                _GlassActionButton(
                  onTap: isListening ? onVoiceStop : onVoiceStart,
                  icon:
                      isListening ? Icons.stop_rounded : Icons.mic_none_rounded,
                  label: isListening ? 'Stop' : 'Voix',
                  color:
                      isListening ? AppColors.error : AppColors.textSecondary,
                  isPulsing: isListening,
                ),
                const SizedBox(width: 10),
              ],
              _GlassActionButton(
                onTap: onPhotoSelect,
                icon: Icons.camera_alt_outlined,
                label: 'Photo',
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 10),
              _GlassActionButton(
                onTap: onBarcodeSelect,
                icon: Icons.qr_code_scanner_rounded,
                label: 'Scan',
                color: AppColors.textSecondary,
              ),
              const Spacer(),
              _AnalyzeButton(isLoading: isLoading, onSubmit: onSubmit),
            ],
          ).animate().fadeIn(delay: 200.ms),

          if (isListening) ...[
            const SizedBox(height: 32),
            Center(
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.error.withValues(alpha: 0.1),
                      border: Border.all(
                        color: AppColors.error.withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Icon(
                      Icons.mic_rounded,
                      color: AppColors.error,
                      size: 32,
                    ),
                  )
                      .animate(onPlay: (c) => c.repeat())
                      .scale(
                        begin: const Offset(1, 1),
                        end: const Offset(1.12, 1.12),
                        duration: 800.ms,
                        curve: Curves.easeInOut,
                      )
                      .then()
                      .scale(
                        begin: const Offset(1.12, 1.12),
                        end: const Offset(1, 1),
                        duration: 800.ms,
                        curve: Curves.easeInOut,
                      ),
                  const SizedBox(height: 14),
                  Text(
                    'À l\'écoute...',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.textSecondary,
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

class _GlassActionButton extends StatelessWidget {
  const _GlassActionButton({
    required this.onTap,
    required this.icon,
    required this.label,
    required this.color,
    this.isPulsing = false,
  });

  final VoidCallback onTap;
  final IconData icon;
  final String label;
  final Color color;
  final bool isPulsing;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.glassWhite,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: color.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: color, size: 18),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: AppTextStyles.labelMedium.copyWith(color: color),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AnalyzeButton extends StatelessWidget {
  const _AnalyzeButton({required this.isLoading, required this.onSubmit});
  final bool isLoading;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onSubmit,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          color: isLoading
              ? AppColors.accent.withValues(alpha: 0.5)
              : AppColors.accent,
          borderRadius: BorderRadius.circular(14),
          boxShadow: isLoading
              ? []
              : [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.black,
                ),
              )
            : Text(
                'Analyser',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Panneau de résultats — Liquid Glass
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
          const SizedBox(height: 12),
          Text(
            'Résultat',
            style: AppTextStyles.displaySmall.copyWith(color: AppColors.white),
          ).animate().fadeIn(),
          const SizedBox(height: 6),
          Text(
            analysis.summary,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ).animate().fadeIn(delay: 80.ms),
          const SizedBox(height: 24),

          // Carte calories principale
          _CalorieResultCard(calories: analysis.calories)
              .animate()
              .scale(delay: 100.ms, curve: Curves.elasticOut),

          const SizedBox(height: 14),

          // Macros grid glass
          _MacrosGlassGrid(analysis: analysis).animate().fadeIn(delay: 180.ms),

          const SizedBox(height: 24),

          // Aliments détectés
          if (analysis.detectedFoods.isNotEmpty) ...[
            Text(
              'Aliments détectés',
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 12),
            ...analysis.detectedFoods.asMap().entries.map(
                  (e) => _FoodItemRow(food: e.value).animate().fadeIn(
                        delay: Duration(milliseconds: 220 + e.key * 50),
                      ),
                ),
            const SizedBox(height: 24),
          ],

          // Actions
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onDiscard,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        height: 54,
                        decoration: BoxDecoration(
                          color: AppColors.glassWhite,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.glassBorder),
                        ),
                        child: Center(
                          child: Text(
                            'Modifier',
                            style: AppTextStyles.labelLarge.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: () => onConfirm(analysis),
                  child: Container(
                    height: 54,
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_rounded,
                            color: AppColors.black, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Enregistrer',
                          style: AppTextStyles.labelLarge.copyWith(
                            color: AppColors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ).animate().fadeIn(delay: 350.ms),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _CalorieResultCard extends StatelessWidget {
  const _CalorieResultCard({required this.calories});
  final int calories;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.accentDim,
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
            border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withValues(alpha: 0.1),
                blurRadius: 30,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Calories estimées',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.accent.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$calories kcal',
                style: AppTextStyles.numeralLarge.copyWith(
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MacrosGlassGrid extends StatelessWidget {
  const _MacrosGlassGrid({required this.analysis});
  final NutritionAnalysis analysis;

  @override
  Widget build(BuildContext context) {
    final macros = [
      (
        'Protéines',
        '${analysis.proteinsG.toStringAsFixed(1)}g',
        AppColors.proteins
      ),
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
        return ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.glassWhite,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: m.$3.withValues(alpha: 0.2)),
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
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.glassWhite,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.name,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    Text(
                      food.portion,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
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
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Feuille scanner code-barres — MobileScanner
// ---------------------------------------------------------------------------

class _BarcodeScannerSheet extends StatefulWidget {
  const _BarcodeScannerSheet();

  @override
  State<_BarcodeScannerSheet> createState() => _BarcodeScannerSheetState();
}

class _BarcodeScannerSheetState extends State<_BarcodeScannerSheet> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );
  bool _scanned = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_scanned) return;
    final raw = capture.barcodes.firstOrNull?.rawValue;
    if (raw == null || raw.isEmpty) return;
    _scanned = true;
    // Renvoie le code-barres pour analyse IA
    Navigator.of(context).pop(
      'Code-barres $raw — analysez les valeurs nutritionnelles de ce produit.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      decoration: const BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textTertiary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Scanner un code-barres',
            style: AppTextStyles.headlineSmall.copyWith(color: AppColors.white),
          ),
          const SizedBox(height: 6),
          Text(
            'Pointez la caméra vers le code-barres du produit.',
            style:
                AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: MobileScanner(
                controller: _controller,
                onDetect: _onDetect,
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: Text(
              'Annuler',
              style: AppTextStyles.labelMedium.copyWith(color: AppColors.error),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
