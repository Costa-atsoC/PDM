import 'package:flutter/material.dart';

class AppTheme {
  //
  AppTheme._();

  //Color.fromARGB(255, 201, 128, 94)

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Color.fromARGB(255, 232, 220, 202),
    appBarTheme: AppBarTheme(
      color: Color.fromARGB(255, 19, 40, 61),
      titleTextStyle: TextStyle(
        fontFamily: 'Lato',
        color: Colors.white,
        fontSize: 25.0,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(
        color: Color.fromARGB(255, 19, 40, 61),
      ),
    ),
    colorScheme: ColorScheme.light(
      primary: Color.fromARGB(255, 255, 255, 252),
      onPrimary: Color.fromARGB(220, 20, 39, 61),
      secondary: Colors.white,
      onSecondary:  Color.fromARGB(220, 20, 39, 61),
    ),
    cardTheme: CardTheme(
      color: Color.fromARGB(220, 33, 65, 101), // Primary color for cards
      shadowColor: Colors.blue, // Secondary color for card shadows
    ),
    iconTheme: IconThemeData(
      color: Colors.white,
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
      scaffoldBackgroundColor: Color.fromARGB(220, 20, 39, 61),
      appBarTheme: AppBarTheme(
        color: Color.fromARGB(255, 19, 40, 61),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      colorScheme: const ColorScheme.dark(
        primary: Color.fromARGB(220, 20, 39, 61),
        onPrimary: Color.fromARGB(255, 255, 255, 252),
        secondary: Colors.white,
        onSecondary:  Color.fromARGB(220, 33, 65, 101),
        primaryContainer: Color.fromARGB(220, 232, 71, 71),
      ),
      cardTheme: CardTheme(
        color: Color.fromARGB(255, 255, 255, 252), // Primary color for cards
        shadowColor: Colors.white, // Secondary color for card shadows
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(
          fontFamily: 'Lato',
          color: Color.fromARGB(255, 255, 255, 255),
          fontSize: 30.0,
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
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: const Color.fromARGB(230, 44, 71, 131),
        splashColor: Colors.white,
        shape: CircleBorder(),
      ),
      inputDecorationTheme: InputDecorationTheme(),


  );
}
