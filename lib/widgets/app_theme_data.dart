import 'package:flutter/material.dart';

class AppThemeData {
  static ThemeData get light => ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: const ColorScheme.light().primary,
          foregroundColor: const ColorScheme.light().onPrimary,
        ),
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 0, 90, 156),
            brightness: Brightness.light),
        useMaterial3: true,
      );
}
