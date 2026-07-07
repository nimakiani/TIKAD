import 'package:flutter/material.dart';

class AppTheme {
  // ==================== تم تاریک ====================
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    // رنگ اصلی تم
    primaryColor: const Color(0xFF7C5CBF),
    scaffoldBackgroundColor: const Color(0xFF0F0F1E),
    cardColor: const Color(0xFF1E1E1E),

    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF9B7BFF),
      secondary: Color(0xFF7C5CBF),
      surface: Color(0xFF1E1E1E),
      background: Color(0xFF121212),
      error: Color(0xFFFF6B6B),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFFE8E8E8),
      onBackground: Color(0xFFE8E8E8),
    ),

    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor:  Color(0xFF0F0F1E),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),

    // Checkbox
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const Color(0xFF9B7BFF);
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      side: const BorderSide(color: Color(0xFF666666), width: 2),
    ),

    // Floating Action Button
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF9B7BFF),
      foregroundColor: Colors.white,
      elevation: 4,
      shape: CircleBorder(),
    ),

    // Text
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Color(0xFFE8E8E8),
      ),
      bodyLarge: TextStyle(fontSize: 16, color: Color(0xFFD0D0D0)),
      bodyMedium: TextStyle(fontSize: 14, color: Color(0xFFB8B8B8)),
      bodySmall: TextStyle(fontSize: 12, color: Color(0xFF888888)),
    ),

    // Input
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2A2A2A),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF9B7BFF), width: 2),
      ),
      hintStyle: const TextStyle(color: Color(0xFF888888)),
    ),

    // Divider
    dividerTheme: const DividerThemeData(
      color: Color(0xFF333333),
      thickness: 1,
    ),

    // Icon
    iconTheme: const IconThemeData(color: Color(0xFFD0D0D0)),

    // ListTile
    listTileTheme: const ListTileThemeData(
      textColor: Colors.white,
      iconColor: Color(0xFFD0D0D0),
    ),
  );

  // ==================== تم روشن ====================
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    // رنگ اصلی تم
    primaryColor: const Color(0xFF7C5CBF),
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    cardColor: Colors.white,

    colorScheme: const ColorScheme.light(
      primary: Color(0xFF7C5CBF),
      secondary: Color(0xFF9B7BFF),
      surface: Colors.white,
      background: Color(0xFFF5F5F5),
      error: Color(0xFFD32F2F),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFF1A1A1A),
      onBackground: Color(0xFF1A1A1A),
    ),

    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF7C5CBF),
      foregroundColor: Colors.white30,
      elevation: 2,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),

    // Checkbox
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const Color(0xFF7C5CBF);
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      side: const BorderSide(color: Color(0xFF999999), width: 2),
    ),

    // Floating Action Button
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF7C5CBF),
      foregroundColor: Colors.white,
      elevation: 4,
      shape: CircleBorder(),
    ),

    // Text
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1A1A1A),
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Color(0xFF2A2A2A),
      ),
      bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF333333)),
      bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF444444)),
      bodySmall: TextStyle(fontSize: 12, color: Color(0xFF777777)),
    ),

    // Input
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFCCCCCC), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF7C5CBF), width: 2),
      ),
      hintStyle: const TextStyle(color: Color(0xFF999999)),
    ),

    // Divider
    dividerTheme: const DividerThemeData(
      color: Color(0xFFE0E0E0),
      thickness: 1,
    ),

    // Icon
    iconTheme: const IconThemeData(color: Color(0xFF444444)),

    // ListTile
    listTileTheme: const ListTileThemeData(
      textColor: Color(0xFF1A1A1A),
      iconColor: Color(0xFF444444),
    ),
  );
}
