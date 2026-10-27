import 'package:flutter/material.dart';

class AppColor {
  static const Color primary = Color(0xff2563EB);
  static const Color secondary = Color(0xff3B82F6);
  static const Color success = Color(0xff10B981);
  static const Color warning = Color(0xffF59E0B);
  static const Color danger = Color(0xffEF4444);

  static const Color background = Color(0xffF8FAFC);
  static const Color card = Colors.white;

  static const Color text = Color(0xff1E293B);
  static const Color subtitle = Color(0xff64748B);
  static const Color border = Color(0xffE2E8F0);
}

class AppTheme {
  // ============================================================
  // LIGHT THEME
  // ============================================================

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    brightness: Brightness.light,

    scaffoldBackgroundColor:
        AppColor.background,

    primaryColor:
        AppColor.primary,

    colorScheme:
        ColorScheme.fromSeed(
      seedColor: AppColor.primary,
      brightness: Brightness.light,
    ),

    appBarTheme:
        const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: AppColor.text,
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),

    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(20),
      ),
    ),

    elevatedButtonTheme:
        ElevatedButtonThemeData(
      style:
          ElevatedButton.styleFrom(
        backgroundColor:
            AppColor.primary,
        foregroundColor:
            Colors.white,
        minimumSize:
            const Size(
          double.infinity,
          55,
        ),
        elevation: 0,
        shape:
            RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(18),
        ),
      ),
    ),

    inputDecorationTheme:
        InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,

      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 18,
      ),

      border:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(16),
        borderSide:
            BorderSide.none,
      ),

      enabledBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(16),
        borderSide:
            const BorderSide(
          color: AppColor.border,
        ),
      ),

      focusedBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(16),
        borderSide:
            const BorderSide(
          color: AppColor.primary,
          width: 2,
        ),
      ),
    ),
  );

  // ============================================================
  // DARK THEME
  // ============================================================

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,

    brightness: Brightness.dark,

    scaffoldBackgroundColor:
        const Color(0xFF0F172A),

    primaryColor:
        AppColor.primary,

    colorScheme:
        ColorScheme.fromSeed(
      seedColor: AppColor.primary,
      brightness: Brightness.dark,
    ),

    appBarTheme:
        const AppBarTheme(
      backgroundColor:
          Color(0xFF0F172A),
      foregroundColor:
          Colors.white,
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),

    cardTheme: CardThemeData(
      color:
          const Color(0xFF1E293B),
      elevation: 2,
      shadowColor:
          Colors.black54,
      shape:
          RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(20),
      ),
    ),

    elevatedButtonTheme:
        ElevatedButtonThemeData(
      style:
          ElevatedButton.styleFrom(
        backgroundColor:
            AppColor.primary,
        foregroundColor:
            Colors.white,
        minimumSize:
            const Size(
          double.infinity,
          55,
        ),
        elevation: 0,
        shape:
            RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(18),
        ),
      ),
    ),

    inputDecorationTheme:
        InputDecorationTheme(
      filled: true,

      fillColor:
          const Color(0xFF1E293B),

      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 18,
      ),

      border:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(16),
        borderSide:
            BorderSide.none,
      ),

      enabledBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(16),
        borderSide:
            const BorderSide(
          color:
              Color(0xFF334155),
        ),
      ),

      focusedBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(16),
        borderSide:
            const BorderSide(
          color:
              AppColor.primary,
          width: 2,
        ),
      ),
    ),
  );
}