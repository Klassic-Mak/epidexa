// ignore_for_file: prefer_const_constructors, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:skinaware_flutter/constants.dart';

ThemeData lightmode = ThemeData(
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Colors.grey,
    selectionColor: primaryColor.withOpacity(0.3),
    // optional
  ),
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: backgroundColor,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
    color: backgroundColor,
    elevation: 0,
    scrolledUnderElevation: 0.0,
  ),
  fontFamily: 'Poppins',
  scaffoldBackgroundColor: backgroundColor,
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primaryContainer: const Color.fromARGB(247, 232, 230, 230),
    background: backgroundColor,
    primary: primaryColor,
  ),
  textTheme: TextTheme(
    bodyMedium: TextStyle(color: Colors.black), // Primary text
  ),
);
