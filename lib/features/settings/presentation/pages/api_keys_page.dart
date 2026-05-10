import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/providers.dart';

/// Page de gestion des clés API.
/// Permet à l'utilisateur de renseigner ses propres clés IA.
class ApiKeysPage extends ConsumerStatefulWidget {
  const ApiKeysPage({super.key});

  @override
  ConsumerState<ApiKeysPage> createState() => _ApiKeysPageState();
}

class _ApiKeysPageState extends ConsumerState<ApiKeysPage> {
  final _controllers = {
    AiProvider.openai: TextEditingController(),
    AiProvider.gemini: TextEditingController(),
    AiProvider.anthropic: TextEditingController(),
  };

  AiProvider _selectedProvider = AiProvider.openai;
  bool _isLoading = false;
  final _obscured = {
    AiProvider.openai: true,
    AiProvider.gemini: true,
    AiProvider.anthropic: true,
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
      if (key != null && key.isNotEmpty) {
        _controllers[provider]!.text = key;
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clés API'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avertissement de sécurité
            _SecurityBanner().animate().fadeIn(),
            const SizedBox(height: 24),

            // Sélection du provider actif
            Text(
              'Fournisseur actif',
              style: AppTextStyles.headlineMedium,
            ),
            const SizedBox(height: 12),
            _ProviderSelector(
              selected: _selectedProvider,
              onChanged: (p) => setState(() => _selectedProvider = p),
            ),
            const SizedBox(height: 28),

            // Champs de clés
            ...AiProvider.values.asMap().entries.map(
                  (e) => _ApiKeyField(
                    provider: e.value,
                    controller: _controllers[e.value]!,
                    isActive: _selectedProvider == e.value,
                    isObscured: _obscured[e.value]!,
                    onToggleVisibility: () => setState(
                      () => _obscured[e.value] = !_obscured[e.value]!,
                    ),
                  ).animate().fadeIn(delay: Duration(milliseconds: e.key * 80)),
                ),

            const SizedBox(height: 32),

            // Bouton sauvegarder
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _saveKeys,
                icon: _isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.white,
                        ),
                      )
                    : const Icon(Icons.save_rounded),
                label: const Text('Sauvegarder'),
              ),
            ),

            const SizedBox(height: 16),

            // Bouton supprimer toutes les clés
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _deleteAllKeys,
                icon: const Icon(Icons.delete_outline_rounded,
                    color: AppColors.error),
                label: Text(
                  'Supprimer toutes les clés',
                  style: TextStyle(color: AppColors.error),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.error),
                ),
              ),
            ),
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
    await prefs.setSelectedProvider(_selectedProvider);

    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Clés API sauvegardées.')),
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
          const SnackBar(content: Text('Clés supprimées.')),
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.success.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.lock_outline_rounded,
            color: AppColors.success,
            size: 24,
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
                Text(
                  'Vos clés API sont chiffrées localement sur votre téléphone via le Keychain/Keystore système. Elles ne quittent jamais votre appareil.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.grey500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProviderSelector extends StatelessWidget {
  const _ProviderSelector({
    required this.selected,
    required this.onChanged,
  });
  final AiProvider selected;
  final ValueChanged<AiProvider> onChanged;

  static const _providerEmojis = {
    AiProvider.openai: '🔮',
    AiProvider.gemini: '✨',
    AiProvider.anthropic: '🤖',
  };

  @override
  Widget build(BuildContext context) {
    return Row(
      children: AiProvider.values.map((p) {
        final isSelected = selected == p;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: p != AiProvider.anthropic ? 8 : 0,
            ),
            child: GestureDetector(
              onTap: () => onChanged(p),
              child: AnimatedContainer(
                duration: AppConstants.animationFast,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.accent.withValues(alpha: 0.1)
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected ? AppColors.accent : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      _providerEmojis[p]!,
                      style: const TextStyle(fontSize: 22),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      p.label,
                      style: AppTextStyles.caption.copyWith(
                        color: isSelected ? AppColors.accent : null,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      p.modelName,
                      style: AppTextStyles.labelSmall.copyWith(
                        fontSize: 9,
                        color: AppColors.grey400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
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
  });

  final AiProvider provider;
  final TextEditingController controller;
  final bool isActive;
  final bool isObscured;
  final VoidCallback onToggleVisibility;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${provider.label} — ${provider.modelName}',
                style: AppTextStyles.labelLarge,
              ),
              if (isActive) ...[
                const SizedBox(width: 8),
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
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.accent,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            obscureText: isObscured,
            style: AppTextStyles.bodyMedium.copyWith(
              fontFamily: 'monospace',
              letterSpacing: isObscured ? 2 : 0,
            ),
            decoration: InputDecoration(
              hintText: 'sk-... ou AIza...',
              suffixIcon: IconButton(
                icon: Icon(
                  isObscured
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  color: AppColors.grey400,
                ),
                onPressed: onToggleVisibility,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
