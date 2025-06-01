import 'package:flutter/material.dart';

class AppTheme {
  // Primary brand colors - matching web version
  static const Color primaryOrange = Color(0xFFEA580C); // Orange-600
  static const Color primaryOrangeDark = Color(0xFFDC2626);

  // Secondary colors
  static const Color secondaryBlue = Color(0xFF2563EB);
  static const Color secondaryGreen = Color(0xFF059669);
  static const Color secondaryPurple = Color(0xFF7C3AED);

  // Neutral colors - matching web version
  static const Color neutral50 = Color(0xFFFAFAFA);
  static const Color neutral100 = Color(0xFFF5F5F5);
  static const Color neutral200 = Color(0xFFE5E5E5);
  static const Color neutral300 = Color(0xFFD4D4D4);
  static const Color neutral400 = Color(0xFFA3A3A3);
  static const Color neutral500 = Color(0xFF737373);
  static const Color neutral600 = Color(0xFF525252);
  static const Color neutral700 = Color(0xFF404040);
  static const Color neutral800 = Color(0xFF262626);
  static const Color neutral900 = Color(0xFF171717);

  // Light theme color scheme - updated to match web
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primaryOrange,
    onPrimary: Colors.white,
    secondary: secondaryBlue,
    onSecondary: Colors.white,
    tertiary: secondaryGreen,
    onTertiary: Colors.white,
    error: Color(0xFFDC2626),
    onError: Colors.white,
    surface: Colors.white,
    onSurface: neutral900,
    outline: neutral300,
    outlineVariant: neutral200,
    surfaceContainerHighest: neutral100,
    onSurfaceVariant: neutral700,
  );

  // Dark theme color scheme - updated to match web
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFFB923C), // Orange-400 for dark mode
    onPrimary: neutral900,
    secondary: Color(0xFF60A5FA), // Blue-400
    onSecondary: neutral900,
    tertiary: Color(0xFF34D399), // Green-400
    onTertiary: neutral900,
    error: Color(0xFFF87171),
    onError: neutral900,
    surface: neutral800,
    onSurface: neutral100,
    outline: neutral600,
    outlineVariant: neutral700,
    surfaceContainerHighest: neutral800,
    onSurfaceVariant: neutral300,
  );

  // Light theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
    fontFamily: 'Inter',
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: neutral900,
      elevation: 0,
      scrolledUnderElevation: 1,
      surfaceTintColor: Colors.transparent,
    ),
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: neutral200, width: 1),
      ),
      color: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primaryOrange,
      unselectedItemColor: neutral500,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: Colors.transparent,
      iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: AppTheme.primaryOrange, size: 24);
        }
        return const IconThemeData(color: AppTheme.neutral700, size: 24);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(
            color: AppTheme.primaryOrange,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          );
        }
        return const TextStyle(
          color: AppTheme.neutral700,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        );
      }),
    ),
  );

  // Dark theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: darkColorScheme,
    fontFamily: 'Inter',
    appBarTheme: const AppBarTheme(
      backgroundColor: neutral800,
      foregroundColor: neutral100,
      elevation: 0,
      scrolledUnderElevation: 1,
      surfaceTintColor: Colors.transparent,
    ),
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: neutral700, width: 1),
      ),
      color: neutral800,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: neutral800,
      selectedItemColor:
          Color(0xFFFB923C), // Changed from Color(0xFFFB923C) to primaryOrange
      unselectedItemColor: neutral400,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: neutral800,
      indicatorColor: Colors.transparent,
      iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
        if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: Color(0xFFFB923C), size: 24);
        }
        return const IconThemeData(color: neutral400, size: 24);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(
            color: Color(0xFFFB923C),
            fontWeight: FontWeight.w600,
            fontSize: 12,
          );
        }
        return const TextStyle(
          color: neutral400,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        );
      }),
    ),
  );

  // Status and semantic colors
  static const Color successColor = secondaryGreen;
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color errorColor = Color(0xFFDC2626);
  static const Color infoColor = secondaryBlue;

  // Grade colors
  static const Color gradeA = successColor;
  static const Color gradeB = secondaryBlue;
  static const Color gradeC = warningColor;
  static const Color gradeD = errorColor;
}
