import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class PremiumCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? borderColor;
  final double? width;
  final double? height;

  const PremiumCard({
    super.key,
    required this.child,
    this.margin,
    this.padding,
    this.borderColor,
    this.width,
    this.height,
  });

  @override
  State<PremiumCard> createState() => _PremiumCardState();
}

class _PremiumCardState extends State<PremiumCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: widget.width,
        height: widget.height,
        margin: widget.margin ?? EdgeInsets.zero,
        padding: widget.padding ?? const EdgeInsets.all(16),
        transform: Matrix4.translationValues(0.0, _isHovered ? -4.0 : 0.0, 0.0),
        decoration: BoxDecoration(
          color: isDark ? AppConstants.surfaceDark : AppConstants.surfaceLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isHovered
                ? (widget.borderColor ?? AppConstants.secondaryColor)
                : (isDark ? AppConstants.borderDark : AppConstants.borderLight),
            width: _isHovered ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? (widget.borderColor ?? AppConstants.secondaryColor).withValues(alpha: 0.15)
                  : Colors.black.withValues(alpha: isDark ? 0.15 : 0.04),
              blurRadius: _isHovered ? 16 : 8,
              spreadRadius: _isHovered ? 1 : 0,
              offset: Offset(0, _isHovered ? 8 : 4),
            ),
          ],
        ),
        child: widget.child,
      ),
    );
  }
}
