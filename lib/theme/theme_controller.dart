import 'package:flutter/material.dart';

class ThemeController {
  // ============================================================
  // GLOBAL THEME MODE
  // ============================================================

  static final ValueNotifier<ThemeMode> mode =
      ValueNotifier<ThemeMode>(ThemeMode.light);

  // ============================================================
  // CEK DARK MODE
  // ============================================================

  static bool get isDark =>
      mode.value == ThemeMode.dark;

  // ============================================================
  // TOGGLE THEME
  // ============================================================

  static void toggle() {
    mode.value = isDark
        ? ThemeMode.light
        : ThemeMode.dark;
  }

  // ============================================================
  // SET DARK
  // ============================================================

  static void setDark() {
    mode.value = ThemeMode.dark;
  }

  // ============================================================
  // SET LIGHT
  // ============================================================

  static void setLight() {
    mode.value = ThemeMode.light;
  }

  // ============================================================
  // TOGGLE THEME
  // VERSI ALIAS
  // ============================================================

  static void toggleTheme() {
    toggle();
  }
}