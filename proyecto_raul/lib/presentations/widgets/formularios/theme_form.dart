import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_raul/presentations/bloc/theme/theme_bloc.dart';
import 'package:proyecto_raul/presentations/bloc/theme/theme_events.dart';
import 'package:proyecto_raul/presentations/funcionalities/get_role.dart';

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    var colorNames = [
      "Azul",
      "Verde azulado",
      "Verde",
      "Rojo",
      "Púrpura",
      "Púrpura intenso",
      "Naranja",
      "Rosa",
      "Rosa intenso"
    ];
    var fontFamilies = ['Arial', 'Courier', 'Georgia', 'Arimo-Regular'];

    Future<void> navigateUser(BuildContext context) async {
      int userRole = await role();
      if (userRole == 1) {
        context.go('/admin');
      } else if (userRole == 2) {
        context.go('/tecnico');
      } else if (userRole == 3) {
        context.go('/user');
      }
    }

    final ThemeBloc themeBloc = context.read<ThemeBloc>();
    final currentThemeState = themeBloc.state.currentTheme;

    int sliderValue = currentThemeState.selectedColor;
    bool isDarkMode = currentThemeState.isDarkmode;
    double sizeText = currentThemeState.sizeText;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Cambiar la fuente",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            DropdownButton<String>(
              value: currentThemeState.selectedFontFamily,
              items: fontFamilies.map((String fontName) {
                return DropdownMenuItem<String>(
                  value: fontName,
                  child: Text(fontName),
                );
              }).toList(),
              onChanged: (String? newValue) {
                themeBloc.add(ThemeSelected(
                  selectedColor: sliderValue.round(),
                  isDarkMode: isDarkMode,
                  sizeText: sizeText,
                  fontFamily: newValue!,
                ));
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Cambiar el color",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            DropdownButton<String>(
              value: colorNames[sliderValue.round()],
              items: colorNames.map((String colorName) {
                return DropdownMenuItem<String>(
                  value: colorName,
                  child: Text(colorName),
                );
              }).toList(),
              onChanged: (String? newValue) {
                sliderValue = colorNames.indexOf(newValue!);
                themeBloc.add(ThemeSelected(
                  selectedColor: sliderValue.round(),
                  isDarkMode: isDarkMode,
                  sizeText: sizeText,
                  fontFamily: currentThemeState.selectedFontFamily,
                ));
              },
            ),
          ],
        ),
        SwitchListTile(
          title: const Text('Modo oscuro'),
          value: isDarkMode,
          onChanged: (bool? value) {
            isDarkMode = value ?? false;
            themeBloc.add(ThemeSelected(
              selectedColor: sliderValue.round(),
              isDarkMode: isDarkMode,
              sizeText: sizeText,
              fontFamily: currentThemeState.selectedFontFamily,
            ));
          },
        ),
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                themeBloc.add(ApplyTheme());
              },
              child: Text('Aceptar',
                  style: Theme.of(context).textTheme.labelLarge),
            ),
            ElevatedButton(
              onPressed: () {
                themeBloc.add(CancelTheme());
                navigateUser(context);
              },
              child: Text('Cancelar',
                  style: Theme.of(context).textTheme.labelLarge),
            ),
          ],
        )
      ],
    );
  }
}
