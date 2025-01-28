import 'package:flutter/material.dart';

const List<Color> colorList = <Color>[
  Colors.blue,
  Colors.teal,
  Colors.green,
  Colors.red, // Usaremos este color de forma puntual, no para todo el tema
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
        textTheme: _buildTextTheme(),
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: colorList[selectedColor]),
          titleTextStyle: titleText,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: isDarkmode ? Colors.black : Colors.white,
            backgroundColor: colorList[selectedColor],
            side: BorderSide(color: colorList[selectedColor], width: 2),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            elevation: 5, // Sombra para mayor destaque
            shadowColor: Colors.black.withOpacity(0.2), // Sombra suave
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

  /// Text Styles
  TextStyle get titleText => TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: colorList[selectedColor],
        fontFamily: selectedFontFamily,
      );

  TextStyle get normalText => TextStyle(
        fontSize: sizeText,
        fontWeight: FontWeight.normal,
        color: isDarkmode ? Colors.white70 : Colors.black87,
        fontFamily: selectedFontFamily,
      );

  TextStyle get boldText => TextStyle(
        fontSize: sizeText,
        fontWeight: FontWeight.bold,
        color: isDarkmode ? Colors.white : Colors.black,
        fontFamily: selectedFontFamily,
      );

  TextStyle get highBoldText => TextStyle(
        fontSize: sizeText + 4,
        fontWeight: FontWeight.bold,
        color: colorList[selectedColor],
        fontFamily: selectedFontFamily,
      );

  // Error Text Style (se usa en casos de error)
  TextStyle get errorText => TextStyle(
        fontSize: sizeText,
        fontWeight: FontWeight.bold,
        color: Colors.red, // Rojo solo para errores
        fontFamily: selectedFontFamily,
      );

  // Warning Text Style (se usa en advertencias)
  TextStyle get warningText => TextStyle(
        fontSize: sizeText,
        fontWeight: FontWeight.normal,
        color: Colors.orangeAccent, // Naranja para advertencias
        fontFamily: selectedFontFamily,
      );

  /// Internal method to build the text theme
  TextTheme _buildTextTheme() => TextTheme(
        displayLarge: titleText,
        bodyLarge: normalText,
        bodyMedium: boldText,
        bodySmall: highBoldText,
        headlineSmall: highBoldText,
      );
}
