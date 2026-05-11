import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/providers.dart';

/// Page de gestion des clés API.
class ApiKeysPage extends ConsumerStatefulWidget {
  const ApiKeysPage({super.key});

  @override
  ConsumerState<ApiKeysPage> createState() => _ApiKeysPageState();
}

class _ApiKeysPageState extends ConsumerState<ApiKeysPage> {
  final _controllers = {
    for (final p in AiProvider.values) p: TextEditingController(),
  };
  final _urlController = TextEditingController();
  final _modelController = TextEditingController();

  AiProvider _selectedProvider = AiProvider.groq;
  bool _isLoading = false;
  final _obscured = {
    for (final p in AiProvider.values) p: true,
  };

  @override
  void initState() {
    super.initState();
    _loadKeys();
  }

  Future<void> _loadKeys() async {
    final prefs = ref.read(preferencesServiceProvider);
    _selectedProvider = await prefs.getSelectedProvider();
    for (final provider in AiProvider.values) {
      final key = await prefs.getApiKey(provider);
      _controllers[provider]!.text = key ?? '';
    }
    final url = await prefs.getBaseUrl(AiProvider.custom);
    _urlController.text = url ?? '';
    final model = await prefs.getModelName(AiProvider.custom);
    _modelController.text = model ?? '';
    setState(() {});
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    _urlController.dispose();
    _modelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final freeProviders = AiProvider.values.where((p) => p.isFree).toList();
    final paidProviders = AiProvider.values
        .where((p) => !p.isFree && p != AiProvider.custom)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Clés API',
          style: AppTextStyles.headlineSmall.copyWith(color: AppColors.white),
        ),
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SecurityBanner().animate().fadeIn(),
            const SizedBox(height: 28),
            Text(
              'Fournisseurs gratuits',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 10),
            _ProviderRow(
              providers: freeProviders,
              selected: _selectedProvider,
              onChanged: (p) => setState(() => _selectedProvider = p),
            ),
            const SizedBox(height: 20),
            Text(
              'Fournisseurs payants',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 10),
            _ProviderRow(
              providers: paidProviders,
              selected: _selectedProvider,
              onChanged: (p) => setState(() => _selectedProvider = p),
            ),
            const SizedBox(height: 20),
            Text(
              'Personnalisé',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                SizedBox(
                  width: 120,
                  child: _ProviderRow(
                    providers: const [AiProvider.custom],
                    selected: _selectedProvider,
                    onChanged: (p) => setState(() => _selectedProvider = p),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            ...AiProvider.values
                .where((p) => p != AiProvider.custom)
                .toList()
                .asMap()
                .entries
                .map(
                  (e) => _ApiKeyField(
                    provider: e.value,
                    controller: _controllers[e.value]!,
                    isActive: _selectedProvider == e.value,
                    isObscured: _obscured[e.value]!,
                    onToggleVisibility: () => setState(
                      () => _obscured[e.value] = !_obscured[e.value]!,
                    ),
                  ).animate().fadeIn(delay: Duration(milliseconds: e.key * 60)),
                ),
            _ApiKeyField(
              provider: AiProvider.custom,
              controller: _controllers[AiProvider.custom]!,
              isActive: _selectedProvider == AiProvider.custom,
              isObscured: _obscured[AiProvider.custom]!,
              onToggleVisibility: () => setState(
                () => _obscured[AiProvider.custom] =
                    !_obscured[AiProvider.custom]!,
              ),
              baseUrlController: _urlController,
              modelController: _modelController,
            ).animate().fadeIn(delay: const Duration(milliseconds: 300)),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: _isLoading ? null : _saveKeys,
              child: Container(
                width: double.infinity,
                height: 54,
                decoration: BoxDecoration(
                  color: _isLoading
                      ? AppColors.accent.withValues(alpha: 0.5)
                      : AppColors.accent,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: _isLoading
                      ? []
                      : [
                          BoxShadow(
                            color: AppColors.accent.withValues(alpha: 0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                ),
                child: Center(
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.black,
                          ),
                        )
                      : Text(
                          'Sauvegarder',
                          style: AppTextStyles.labelLarge.copyWith(
                            color: AppColors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _deleteAllKeys,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    width: double.infinity,
                    height: 54,
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.error.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Supprimer toutes les clés',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Future<void> _saveKeys() async {
    setState(() => _isLoading = true);
    final prefs = ref.read(preferencesServiceProvider);

    for (final provider in AiProvider.values) {
      final key = _controllers[provider]!.text.trim();
      if (key.isNotEmpty) {
        await prefs.saveApiKey(provider, key);
      } else {
        await prefs.deleteApiKey(provider);
      }
    }
    await prefs.saveBaseUrl(AiProvider.custom, _urlController.text.trim());
    await prefs.saveModelName(AiProvider.custom, _modelController.text.trim());
    await prefs.setSelectedProvider(_selectedProvider);

    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Clés API sauvegardées.',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.white),
          ),
          backgroundColor: AppColors.surfaceTertiaryDark,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  Future<void> _deleteAllKeys() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer les clés API'),
        content: const Text(
          'Toutes vos clés API seront supprimées. Vous devrez les reconfigurer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ref.read(preferencesServiceProvider).clearAllApiKeys();
      for (final c in _controllers.values) {
        c.clear();
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Clés supprimées.',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.white),
            ),
            backgroundColor: AppColors.surfaceTertiaryDark,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }
}

// ---------------------------------------------------------------------------
// Composants
// ---------------------------------------------------------------------------

class _SecurityBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.success.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.lock_outline_rounded,
                color: AppColors.success,
                size: 22,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Stockage chiffré',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.success,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Clés chiffrées localement via Keychain/Keystore. Elles ne quittent pas votre appareil.',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProviderRow extends StatelessWidget {
  const _ProviderRow({
    required this.providers,
    required this.selected,
    required this.onChanged,
  });
  final List<AiProvider> providers;
  final AiProvider selected;
  final ValueChanged<AiProvider> onChanged;

  static const _providerIcons = {
    AiProvider.groq: Icons.bolt_rounded,
    AiProvider.mistral: Icons.air_rounded,
    AiProvider.gemini: Icons.auto_awesome_rounded,
    AiProvider.openai: Icons.circle_outlined,
    AiProvider.anthropic: Icons.psychology_rounded,
    AiProvider.custom: Icons.tune_rounded,
  };

  @override
  Widget build(BuildContext context) {
    return Row(
      children: providers.asMap().entries.map((e) {
        final p = e.value;
        final isSelected = selected == p;
        final isLast = e.key == providers.length - 1;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: isLast ? 0 : 8),
            child: GestureDetector(
              onTap: () => onChanged(p),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: AnimatedContainer(
                    duration: AppConstants.animationFast,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.accentDim
                          : AppColors.glassWhite,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.accent.withValues(alpha: 0.4)
                            : AppColors.glassBorder,
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          _providerIcons[p]!,
                          color: isSelected
                              ? AppColors.accent
                              : AppColors.textSecondary,
                          size: 20,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          p.label,
                          style: AppTextStyles.caption.copyWith(
                            color:
                                isSelected ? AppColors.accent : AppColors.white,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          p.modelName,
                          style: AppTextStyles.caption.copyWith(
                            fontSize: 9,
                            color: AppColors.textTertiary,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ApiKeyField extends StatelessWidget {
  const _ApiKeyField({
    required this.provider,
    required this.controller,
    required this.isActive,
    required this.isObscured,
    required this.onToggleVisibility,
    this.baseUrlController,
    this.modelController,
  });

  final AiProvider provider;
  final TextEditingController controller;
  final bool isActive;
  final bool isObscured;
  final VoidCallback onToggleVisibility;
  final TextEditingController? baseUrlController;
  final TextEditingController? modelController;

  String get _hintText {
    switch (provider) {
      case AiProvider.groq:
        return 'gsk_... (gratuit sur console.groq.com)';
      case AiProvider.mistral:
        return 'Clé Mistral (gratuit sur console.mistral.ai)';
      case AiProvider.gemini:
        return 'AIza... (Google AI Studio)';
      case AiProvider.openai:
        return 'sk-...';
      case AiProvider.anthropic:
        return 'sk-ant-...';
      case AiProvider.custom:
        return 'Clé API (optionnelle si pas d\'authentification)';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isActive ? AppColors.accentDim : AppColors.glassWhite,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isActive
                    ? AppColors.accent.withValues(alpha: 0.3)
                    : AppColors.glassBorder,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      provider.label,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '— ${provider.modelName}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    if (provider.isFree)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: AppColors.success.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Text(
                          'Gratuit',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.success,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    if (isActive) ...[
                      if (provider.isFree) const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Actif',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.accent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 10),
                if (provider == AiProvider.custom) ..._buildCustomFields()
                else
                TextField(
                  controller: controller,
                  obscureText: isObscured,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.white,
                    fontFamily: 'monospace',
                    letterSpacing: isObscured ? 2 : 0,
                  ),
                  decoration: InputDecoration(
                    hintText: _hintText,
                    hintStyle: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textTertiary,
                    ),
                    fillColor: AppColors.glassWhite,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: AppColors.glassBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: AppColors.glassBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.accent,
                        width: 1.5,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isObscured
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        color: AppColors.textTertiary,
                        size: 20,
                      ),
                      onPressed: onToggleVisibility,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCustomFields() {
    final inputDeco = InputDecoration(
      fillColor: AppColors.glassWhite,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.glassBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.glassBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
      ),
    );

    return [
      Text(
        'URL de base',
        style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
      ),
      const SizedBox(height: 6),
      TextField(
        controller: baseUrlController,
        autocorrect: false,
        keyboardType: TextInputType.url,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.white,
          fontFamily: 'monospace',
        ),
        decoration: inputDeco.copyWith(
          hintText: 'https://api.example.com/v1',
          hintStyle: AppTextStyles.bodySmall
              .copyWith(color: AppColors.textTertiary),
        ),
      ),
      const SizedBox(height: 10),
      Text(
        'Clé API',
        style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
      ),
      const SizedBox(height: 6),
      TextField(
        controller: controller,
        obscureText: isObscured,
        autocorrect: false,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.white,
          fontFamily: 'monospace',
          letterSpacing: isObscured ? 2 : 0,
        ),
        decoration: inputDeco.copyWith(
          hintText: 'Clé API (optionnelle)',
          hintStyle: AppTextStyles.bodySmall
              .copyWith(color: AppColors.textTertiary),
          suffixIcon: IconButton(
            icon: Icon(
              isObscured
                  ? Icons.visibility_off_rounded
                  : Icons.visibility_rounded,
              color: AppColors.textTertiary,
              size: 20,
            ),
            onPressed: onToggleVisibility,
          ),
        ),
      ),
      const SizedBox(height: 10),
      Text(
        'Modèle',
        style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
      ),
      const SizedBox(height: 6),
      TextField(
        controller: modelController,
        autocorrect: false,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.white,
          fontFamily: 'monospace',
        ),
        decoration: inputDeco.copyWith(
          hintText: 'model-name',
          hintStyle: AppTextStyles.bodySmall
              .copyWith(color: AppColors.textTertiary),
        ),
      ),
    ];
  }
}
