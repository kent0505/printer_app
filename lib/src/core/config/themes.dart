import 'package:flutter/material.dart';

import 'constants.dart';
import 'my_colors.dart';

final _ligth = MyColors.light();

final lightTheme = ThemeData(
  useMaterial3: false,
  brightness: Brightness.light,
  fontFamily: AppFonts.inter400,
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: _ligth.accentPrimary,
    selectionColor: _ligth.accentPrimary,
    selectionHandleColor: _ligth.accentPrimary,
  ),

  // OVERSCROLL
  colorScheme: ColorScheme.light(
    surface: _ligth.bgOne, // bg color when push
    secondary: _ligth.tertiaryThree, // overscroll
  ),

  // SCAFFOLD
  scaffoldBackgroundColor: _ligth.bgOne,

  // APPBAR
  appBarTheme: AppBarTheme(
    backgroundColor: _ligth.bgOne,
    centerTitle: true,
    toolbarHeight: 60, // app bar size
    elevation: 0,
    actionsPadding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 8,
    ),
    titleTextStyle: TextStyle(
      color: _ligth.textPrimary,
      fontSize: 18,
      fontFamily: AppFonts.inter600,
    ),
    shape: Border(
      bottom: BorderSide(
        width: 1,
        color: _ligth.tertiaryThree,
      ),
    ),
  ),

  // DIALOG
  dialogTheme: const DialogTheme(
    insetPadding: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
    ),
  ),

  // TEXTFIELD
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    // fillColor: _ligth.tertiaryOne,
    contentPadding: const EdgeInsets.symmetric(
      vertical: 16,
      horizontal: 16,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Colors.transparent),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Colors.transparent),
    ),
    hintStyle: TextStyle(
      color: _ligth.textSecondary,
      fontSize: 14,
      fontFamily: AppFonts.inter400,
    ),
  ),

  // BOTTOM SHEET
  // bottomSheetTheme: BottomSheetThemeData(
  //   backgroundColor: _ligth.bg,
  // ),
  extensions: [_ligth],
);
