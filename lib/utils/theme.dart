import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  colorScheme: const ColorScheme.light(
    primary: Colors.blue,
    secondary: Colors.blueAccent,
  ),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
        fontSize: 16.0, color: Colors.black87, fontFamily: 'AbyssinicaSIL'),
    bodyMedium: TextStyle(
        fontSize: 14.0, color: Colors.black87, fontFamily: 'AbyssinicaSIL'),
  ),
  fontFamily: 'AbyssinicaSIL',
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.blueGrey,
  colorScheme: const ColorScheme.dark(
    primary: Colors.blueGrey,
    secondary: Colors.lightBlue,
  ),
  scaffoldBackgroundColor: Colors.grey[900],
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey[900],
    foregroundColor: Colors.white,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
        fontSize: 16.0, color: Colors.white, fontFamily: 'AbyssinicaSIL'),
    bodyMedium: TextStyle(
        fontSize: 14.0, color: Colors.white70, fontFamily: 'AbyssinicaSIL'),
  ),
  fontFamily: 'AbyssinicaSIL',
);
