import 'package:flutter/material.dart';

import '../util/app_export.dart';

class CustomButtonStyles {
  // Filled button style
  static ButtonStyle get fillPrimary => ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary.withOpacity(1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(
            right: Radius.circular(
              5.h,
            ),
          ),
        ),
      );

  static ButtonStyle get outlineButtonGreen500 => ElevatedButton.styleFrom(
        backgroundColor: appTheme.green500.withOpacity(1),
        textStyle: theme.textTheme.titleLarge,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
      );

  static ButtonStyle get outlineButtonRed500 => ElevatedButton.styleFrom(
        backgroundColor: appTheme.red500.withOpacity(1),
        textStyle: theme.textTheme.titleLarge,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
      );

  static ButtonStyle get outlineButtonGrey300 => ElevatedButton.styleFrom(
        backgroundColor: appTheme.grey300.withOpacity(1),
        textStyle: theme.textTheme.titleLarge,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
      );

  // text button style
  static ButtonStyle get none => ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
        elevation: MaterialStateProperty.all<double>(0),
      );

  // text button style
  static ButtonStyle get black => ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
        elevation: MaterialStateProperty.all<double>(0),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
      );
}
