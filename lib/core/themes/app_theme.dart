import 'package:education_app/core/themes/app_font.dart';
import 'package:education_app/core/themes/app_pallete.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
    ),
    fontFamily: AppFont.poppins,
    colorScheme: ColorScheme.fromSwatch(accentColor: AppPallete.primaryColour),
  );
}
