import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygallerybook/core/app_colors.dart';

class AppTheme {
  static ThemeData getMyGalleryBookTheme() {
    return ThemeData.from(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.blue,
          // brightness: Brightness.dark,
        ).copyWith(
          primary: AppColors.blue,
        ),
        textTheme: TextTheme(
            bodyLarge: GoogleFonts.nunito(
                textStyle: const TextStyle(
              inherit: true,
              fontSize: 23,
              fontWeight: FontWeight.w800,
            )),
            bodyMedium: GoogleFonts.nunito(
              textStyle: const TextStyle(
                inherit: true,
                fontSize: 20,
              ),
            ),
            bodySmall: GoogleFonts.lato(
                textStyle: const TextStyle(
                    inherit: true,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    fontStyle: FontStyle.italic))));
  }
}
