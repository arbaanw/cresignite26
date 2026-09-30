import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Renders a warm, craft-inspired placeholder "photo" for a product using
/// only local gradients + icons, so the app never depends on network
/// images or missing assets.
class CraftVisual extends StatelessWidget {
  final int visualIndex;
  final bool enhanced;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const CraftVisual({
    super.key,
    required this.visualIndex,
    this.enhanced = false,
    this.width,
    this.height,
    this.borderRadius,
  });

  static const _icons = [
    Icons.checkroom,
    Icons.shopping_basket_outlined,
    Icons.local_florist_outlined,
    Icons.shopping_bag_outlined,
    Icons.dry_cleaning_outlined,
  ];

  static const _gradients = [
    [Color(0xFF5A1F2B), Color(0xFF8C3A46)],
    [Color(0xFFB96E58), Color(0xFFD79A83)],
    [Color(0xFF7C4A3A), Color(0xFFB08968)],
    [Color(0xFF3F6355), Color(0xFF6F9C89)],
    [Color(0xFF6B4F80), Color(0xFFB8A1C8)],
  ];

  @override
  Widget build(BuildContext context) {
    final safeIndex = visualIndex % _icons.length;
    final base = _gradients[safeIndex];
    final gradientColors = enhanced ? [base[0], AppColors.lavender] : base;
    final iconSize = (height ?? 160) * 0.36;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: 0.16,
            child: Icon(Icons.blur_on, size: (height ?? 160) * 0.85, color: Colors.white),
          ),
          Icon(_icons[safeIndex], size: iconSize, color: Colors.white.withOpacity(0.95)),
          if (enhanced)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.92),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome, size: 12, color: AppColors.burgundy),
                    SizedBox(width: 4),
                    Text(
                      'AI Enhanced',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.burgundy),
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
