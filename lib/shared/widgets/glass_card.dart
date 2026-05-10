import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';

/// Widget réutilisable — carte en verre liquide (Liquid Glass).
/// Encapsule BackdropFilter + blur + glass overlay + bordure subtile.
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.color,
    this.borderColor,
    this.blur = 15.0,
    this.shadows,
    this.onTap,
    this.margin,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Color? color;
  final Color? borderColor;
  final double blur;
  final List<BoxShadow>? shadows;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final radius =
        borderRadius ?? BorderRadius.circular(AppConstants.borderRadius);
    final card = ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: color ?? AppColors.glassWhite,
            borderRadius: radius,
            border: Border.all(
              color: borderColor ?? AppColors.glassBorder,
            ),
            boxShadow: shadows,
          ),
          child: child,
        ),
      ),
    );

    return Container(
      margin: margin,
      child: onTap != null
          ? GestureDetector(onTap: onTap, child: card)
          : card,
    );
  }
}

/// Variante avec effet de lueur en bordure (pour les cartes actives).
class GlassCardGlow extends StatelessWidget {
  const GlassCardGlow({
    super.key,
    required this.child,
    this.padding,
    this.color = AppColors.accentDim,
    this.glowColor = AppColors.accentGlow,
    this.borderColor,
    this.blur = 20.0,
    this.glowRadius = 24.0,
    this.borderRadius,
    this.onTap,
    this.margin,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color color;
  final Color glowColor;
  final Color? borderColor;
  final double blur;
  final double glowRadius;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final radius =
        borderRadius ?? BorderRadius.circular(AppConstants.borderRadiusLarge);
    return GlassCard(
      key: key,
      padding: padding,
      borderRadius: radius,
      color: color,
      borderColor: borderColor ?? AppColors.accent.withValues(alpha: 0.3),
      blur: blur,
      shadows: [
        BoxShadow(
          color: glowColor,
          blurRadius: glowRadius,
          spreadRadius: 2,
        ),
      ],
      onTap: onTap,
      margin: margin,
      child: child,
    );
  }
}
