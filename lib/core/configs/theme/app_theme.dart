import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
class AppTheme{
  static final appTheme = ThemeData(
    fontFamily: GoogleFonts.urbanist().fontFamily, //make sure it works
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.backgroundColor,
    // brightness: Brightness.dark,
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondaryColor,
              foregroundColor: Colors.white,
              // elevation: 0,
              textStyle: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold,),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r)
              )
          )
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.w400
        ),
        contentPadding: EdgeInsets.all(12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.black)
        )
  )
  );
}