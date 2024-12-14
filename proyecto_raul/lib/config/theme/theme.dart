import 'package:flutter/material.dart';

const List<Color> colorList = <Color>[
  Colors.blue,
  Colors.teal,
  Colors.green,
  Colors.red,
  Colors.purple,
  Colors.deepPurple,
  Colors.orange,
  Colors.pink,
  Colors.pinkAccent,
];

const List<String> fontFamilies = <String>[
  'Arial',
  'Courier',
  'Georgia',
  'Arimo-Regular'
];

class AppTheme {
  final bool useMaterial3;
  final int selectedColor;
  final bool isDarkmode;
  final double sizeText;
  final String selectedFontFamily;

  AppTheme({
    this.useMaterial3 = true,
    this.selectedColor = 0,
    this.isDarkmode = false,
    this.sizeText = 18,
    this.selectedFontFamily = 'Arial',
  });

  ThemeData getTheme() => ThemeData(
        useMaterial3: useMaterial3,
        brightness: isDarkmode ? Brightness.dark : Brightness.light,
        colorSchemeSeed: colorList[selectedColor],
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: colorList[selectedColor]),
          titleTextStyle: TextStyle(
              color: colorList[selectedColor],
              fontSize: 20,
              fontFamily: selectedFontFamily),
        ),
        textTheme: TextTheme(
          displayLarge: TextStyle(
            fontSize: 30,
            color: isDarkmode ? Colors.white : Colors.black,
            fontFamily: selectedFontFamily,
          ),
          bodyLarge: TextStyle(
            fontSize: sizeText,
            color: isDarkmode ? Colors.white70 : Colors.black87,
            fontFamily: selectedFontFamily,
          ),
          bodyMedium: TextStyle(
            color: isDarkmode ? Colors.white70 : Colors.black87,
            fontFamily: selectedFontFamily,
          ),
          bodySmall: TextStyle(
            fontSize: 15,
            color: isDarkmode ? Colors.white70 : Colors.black87,
            fontFamily: selectedFontFamily,
          ),
          labelLarge: TextStyle(
            fontSize: sizeText,
            color: colorList[selectedColor],
            fontFamily: selectedFontFamily,
          ),
          titleLarge: TextStyle(
            fontSize: 28.0,
            color: colorList[selectedColor],
            fontFamily: selectedFontFamily,
          ),
          headlineSmall: TextStyle(
            fontSize: 14.0,
            color: colorList[selectedColor],
            fontFamily: selectedFontFamily,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: isDarkmode ? Colors.black : Colors.white,
            backgroundColor: isDarkmode ? Colors.black : Colors.white,
            side: BorderSide(color: colorList[selectedColor], width: 2),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: colorList[selectedColor],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: isDarkmode ? Colors.grey[800] : Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: colorList[selectedColor],
            ),
          ),
        ),
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: colorList[selectedColor],
              width: 2,
            ),
          ),
        ),
      );

  double get circularContainerSize => 40.0;

  Color get circularContainerColor => colorList[selectedColor];

  ButtonStyle get inventarisButtonStyle => ElevatedButton.styleFrom(
        backgroundColor: Colors.red.shade200,
        foregroundColor: Colors.red.shade700,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      );

  RoundedRectangleBorder get inventarisCardShape => RoundedRectangleBorder(
        side: BorderSide(
          color: colorList[selectedColor],
          width: 2,
        ),
      );

  InputDecoration get inputDecoration => InputDecoration(
        fillColor: isDarkmode ? Colors.grey[800] : Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: colorList[selectedColor],
          ),
        ),
      );

  TextStyle get appTextTab => TextStyle(color: colorList[selectedColor]);

  TextStyle get appTab => TextStyle(color: colorList[selectedColor]);

  TextStyle get textUser => TextStyle(
        fontSize: 28.0,
        color: colorList[selectedColor],
        fontFamily: selectedFontFamily,
      );

  TextStyle get textRole => TextStyle(
        fontSize: 14.0,
        color: colorList[selectedColor],
        fontFamily: selectedFontFamily,
      );

  TextStyle get textSetings => TextStyle(
        fontSize: sizeText,
        color: colorList[selectedColor],
        fontFamily: selectedFontFamily,
      );

  TextStyle get appTitle => TextStyle(
        fontSize: 30,
        color: colorList[selectedColor],
        fontFamily: selectedFontFamily,
      );

  TextStyle get appSubitle => TextStyle(
        fontSize: 15,
        color: colorList[selectedColor],
        fontFamily: selectedFontFamily,
      );

  ButtonStyle get circle => ElevatedButton.styleFrom(
        backgroundColor: isDarkmode ? Colors.black : Colors.white,
        side: BorderSide(color: colorList[selectedColor], width: 2),
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(0),
      );
}
