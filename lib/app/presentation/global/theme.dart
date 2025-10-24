import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokemon_app/app/presentation/global/colors.dart';

ThemeData getTheme(bool darkMode) {
  if (darkMode) {
    return ThemeData.dark().copyWith(
      textTheme: GoogleFonts.nunitoSansTextTheme(
        ThemeData.dark().textTheme.copyWith(
          titleSmall: const TextStyle(fontWeight: FontWeight.bold),
          titleMedium: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          titleLarge: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      scaffoldBackgroundColor: AppColors.darkLight,
      appBarTheme: const AppBarThemeData(
        backgroundColor: AppColors.dark,
        elevation: 0,
      ),
      canvasColor: AppColors.dark,
      switchTheme: SwitchThemeData(
        thumbColor: const WidgetStatePropertyAll(Colors.blue),
        trackColor: WidgetStatePropertyAll(
          Colors.lightBlue.withValues(alpha: 0.5),
        ),
      ),
    );
  }
  return ThemeData.light().copyWith(
    textTheme: GoogleFonts.nunitoSansTextTheme(
      ThemeData.light().textTheme.copyWith(
        titleSmall: const TextStyle(
          color: AppColors.dark,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: const TextStyle(
          color: AppColors.dark,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    ),
    appBarTheme: const AppBarThemeData(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.dark),
      titleTextStyle: TextStyle(color: AppColors.dark),
    ),
    tabBarTheme: const TabBarThemeData(labelColor: AppColors.dark),
  );
}
