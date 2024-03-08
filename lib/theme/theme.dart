import 'package:flutter/material.dart';

ThemeData light=ThemeData(
  brightness: Brightness.light,
    appBarTheme: const AppBarTheme(centerTitle: true),
    colorSchemeSeed: MaterialStateColor.resolveWith((states) => Colors.lightBlue.shade50),
    textTheme: TextTheme(titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),labelLarge: TextStyle(color: Colors.lightBlue))
);
ThemeData dark=ThemeData(
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(centerTitle: true),
    colorSchemeSeed: MaterialStateColor.resolveWith((states) => Colors.lightBlue.shade50),
    textTheme: TextTheme(titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),labelLarge: TextStyle(color: Colors.lightBlue))
);