import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'Smart Attendance';
  
  // Design system colors
  static const Color primaryColor = Color(0xFF1E3A8A); // Deep navy blue
  static const Color secondaryColor = Color(0xFF3B82F6); // Bright blue
  static const Color accentColor = Color(0xFF10B981); // Emerald green (Present)
  static const Color warningColor = Color(0xFFF59E0B); // Amber (Late/Pending)
  static const Color dangerColor = Color(0xFFEF4444); // Red (Absent/Rejected)
  static const Color infoColor = Color(0xFF8B5CF6); // Purple (Half day)

  // Neutral Colors (Light Theme)
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Colors.white;
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color borderLight = Color(0xFFE2E8F0);

  // Neutral Colors (Dark Theme)
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color borderDark = Color(0xFF334155);

  // Office Geofence Coordinates
  static const double officeLatitude = 18.5204;
  static const double officeLongitude = 73.8567;
  static const double geofenceRadiusMeters = 200.0;

  static PreferredSizeWidget buildBrandingAppBar({
    required BuildContext context,
    required String title,
    List<Widget>? actions,
    PreferredSizeWidget? bottom,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFF1E3A8A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            alignment: Alignment.center,
            child: const Text(
              'ISG',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'ISG eSolutions',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : primaryColor,
              fontSize: 18,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '|  $title',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      actions: actions,
      bottom: bottom,
    );
  }
}
