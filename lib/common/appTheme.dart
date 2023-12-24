import 'package:flutter/material.dart';

class AppTheme {
  //
  AppTheme._();

  //Color.fromARGB(255, 201, 128, 94)

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    //scaffoldBackgroundColor: const Color.fromARGB(255, 245, 237, 225),
    scaffoldBackgroundColor: const Color.fromARGB(255, 250, 249, 247),
    appBarTheme: const AppBarTheme(
      color: Color.fromARGB(255, 234, 234, 230),
      // color: Color.fromARGB(255, 35, 40, 56),
      titleTextStyle: TextStyle(
        fontFamily: 'Lato',
        color: Colors.white,
        fontSize: 25.0,
        fontWeight: FontWeight.bold,
      ),
    ),
    colorScheme: const ColorScheme.light(

      primary: Color.fromARGB(255, 19, 40, 61),
      onPrimary:Color.fromARGB(255, 59, 60, 54),

      secondary: Colors.white,
      onSecondary: Color.fromARGB(220, 35, 40, 56),
      primaryContainer: Color.fromARGB(255, 201, 128, 94),
      secondaryContainer: Color.fromARGB(255, 201, 128, 94),
    ),
    cardTheme: const CardTheme(
      color: Color.fromARGB(255, 250, 249, 247), // Primary color for cards// Secondary color for card shadows
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    textTheme: const TextTheme(
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
      labelLarge: TextStyle(
        color: Color.fromARGB(255, 20, 39, 61),
        fontFamily: 'Lato',
        fontSize: 14,
      ),
      labelMedium: TextStyle(
        color: Color.fromARGB(255, 20, 39, 61),
        fontFamily: 'Lato',
        fontSize: 12,
      ),
      labelSmall: TextStyle(
        color: Color.fromARGB(255, 20, 39, 61),
        fontFamily: 'Lato',
        fontSize: 10,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        minimumSize: const Size(double.infinity, 0),
        backgroundColor: const Color.fromARGB(255, 208, 166, 144),
        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(8.0), // Adjust the radius as needed
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        backgroundColor: MaterialStateProperty.all<Color>(
          const Color.fromARGB(255, 201, 128, 94),
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        minimumSize: const Size(double.infinity, 0),
        backgroundColor:
        const Color.fromARGB(255, 208, 166, 144), // Adjust color as needed
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color.fromARGB(255, 201, 128, 94),
      splashColor: Colors.white,
      shape: CircleBorder(),
    ),
  );

  // -------- DARK THEME
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: const Color.fromARGB(255, 24, 26, 37),
    appBarTheme: const AppBarTheme(
      color: Color.fromARGB(255, 24, 26, 37),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    colorScheme: const ColorScheme.dark(
      primary: Color.fromARGB(255, 35, 40, 56),
      onPrimary: Color.fromARGB(255, 234, 234, 230),
      secondary: Colors.white,
      onSecondary: Color.fromARGB(220, 33, 65, 101),
      primaryContainer: Color.fromARGB(220, 232, 71, 71),
      secondaryContainer: Color.fromARGB(255, 201, 128, 94),
    ),
    cardTheme: const CardTheme(
      color: Color.fromARGB(220, 35, 40, 56), // Primary color for cards
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    textTheme: const TextTheme(
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
      labelLarge: TextStyle(
        color: Colors.white,
        fontFamily: 'Lato',
        fontSize: 14,
      ),
      labelMedium: TextStyle(
        color: Colors.white,
        fontFamily: 'Lato',
        fontSize: 12,
      ),
      labelSmall: TextStyle(
        color: Colors.white,
        fontFamily: 'Lato',
        fontSize: 10,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        minimumSize: const Size(double.infinity, 0),
        backgroundColor: const Color.fromARGB(255, 201, 128, 94),
        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(8.0), // Adjust the radius as needed
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        backgroundColor: MaterialStateProperty.all<Color>(
          const Color.fromARGB(255, 201, 128, 94),
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        minimumSize: const Size(double.infinity, 0),
        backgroundColor:
        const Color.fromARGB(255, 201, 128, 94), // Adjust color as needed
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color.fromARGB(255, 201, 128, 94),
      splashColor: Colors.white,
      shape: CircleBorder(),
    ),
    inputDecorationTheme: const InputDecorationTheme(),
  );
}