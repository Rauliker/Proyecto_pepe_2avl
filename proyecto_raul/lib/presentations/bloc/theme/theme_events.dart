abstract class ThemeEvent {}

class ThemeSelected extends ThemeEvent {
  final int selectedColor;
  final bool isDarkMode;
  final double sizeText;
  final String fontFamily;

  ThemeSelected({
    required this.selectedColor,
    required this.isDarkMode,
    required this.sizeText,
    required this.fontFamily,
  });
}

class ApplyTheme extends ThemeEvent {}

class CancelTheme extends ThemeEvent {}
