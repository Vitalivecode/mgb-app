import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygallerybook/core/app_colors.dart';

class AppTheme {
  static ThemeData getMyGalleryBookTheme() {
    final nunitoTheme = GoogleFonts.nunitoTextTheme();
    final latoTheme = GoogleFonts.latoTextTheme();

    return ThemeData.from(
      useMaterial3: false,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.darkBlue,
      ).copyWith(
        primary: AppColors.darkBlue,
      ),
      textTheme: nunitoTheme.copyWith(
        bodySmall: latoTheme.bodySmall,
        bodyLarge: latoTheme.bodyLarge,
        bodyMedium: latoTheme.bodyMedium,
      ),
    );
  }
}
