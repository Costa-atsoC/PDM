import 'package:flutter/material.dart';

class AppTheme {
  //
  AppTheme._();

  //Color.fromARGB(255, 201, 128, 94)

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Color.fromARGB(255, 255, 255, 252),
    appBarTheme: AppBarTheme(
      color: Color.fromARGB(230, 9, 21, 27),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    colorScheme: ColorScheme.light(
      primary: Color.fromARGB(255, 20, 39, 61),
      onPrimary: Color.fromARGB(255, 20, 39, 61),
      secondary: Colors.white,
    ),
    cardTheme: CardTheme(
      color: Colors.teal,
    ),
    iconTheme: IconThemeData(
      color: Color.fromARGB(255, 20, 39, 61),
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontFamily: 'Lato',
        color: Colors.white,
        fontSize: 25.0,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(
        fontFamily: 'Lato',
        fontWeight: FontWeight.bold,
        color: Color.fromARGB(255, 20, 39, 61),
        fontSize: 20.0,
      ),
      titleSmall: TextStyle(
          color: Color.fromARGB(255, 20, 39, 61),
          fontFamily: 'Lato',
          fontSize: 17,
          fontWeight: FontWeight.bold),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        minimumSize: Size(double.infinity, 0),
        backgroundColor: Color.fromARGB(255, 208, 166, 144),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        backgroundColor: MaterialStateProperty.all<Color>(
          Color.fromARGB(255, 201, 128, 94),
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        minimumSize: Size(double.infinity, 0),
        backgroundColor:
            Color.fromARGB(255, 208, 166, 144), // Adjust color as needed
      ),
    ),
  );

  // -------- DARK THEME
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Color.fromARGB(255, 20, 39, 61),
    appBarTheme: AppBarTheme(
      color: Color.fromARGB(130, 9, 21, 27),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    colorScheme: ColorScheme.light(
      primary: Color.fromARGB(130, 9, 21, 27),
      onPrimary: Colors.white,
      secondary: Colors.white,
    ),
    cardTheme: CardTheme(
      color: Colors.black,
    ),
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontFamily: 'Lato',
        color: Color.fromARGB(255, 255, 255, 255),
        fontSize: 25.0,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
      ),
      titleSmall: TextStyle(
        color: Colors.white,
        fontFamily: 'Lato',
        fontSize: 17,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        minimumSize: Size(double.infinity, 0),
        backgroundColor: Color.fromARGB(255, 201, 128, 94),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        backgroundColor: MaterialStateProperty.all<Color>(
          Color.fromARGB(255, 201, 128, 94),
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        minimumSize: Size(double.infinity, 0),
        backgroundColor:
            Color.fromARGB(255, 201, 128, 94), // Adjust color as needed
      ),
    ),
  );
}
