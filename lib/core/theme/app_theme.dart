import 'package:expense_tracker_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final appTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppColors.light100,
    appBarTheme: const AppBarTheme(
      color: AppColors.light100,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: AppColors.light60,
          width: 2,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: AppColors.light60,
          width: 2,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: AppColors.dark100,
          width: 2,
        ),
      ),
      hintStyle: const TextStyle(
        fontFamily: 'Inter',
        color: AppColors.light20,
        fontSize: 16,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16,vertical: 18),
    ),
  );
}