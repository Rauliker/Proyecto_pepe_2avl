import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:proyecto_raul/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeLanguageScreen extends StatelessWidget {
  const ChangeLanguageScreen({super.key});

  Future<void> _changeLanguage(
      BuildContext context, Locale locale, String langCode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lang', langCode);

    MyApp.of(context)?.setLocale(locale);
  }

  Widget buildCountryTile(
    BuildContext context, {
    required String langCode,
    required Locale locale,
    required String countryCode,
    required String language,
  }) {
    return ListTile(
      leading: Text(
        Country.parse(countryCode).flagEmoji,
        style: const TextStyle(fontSize: 24),
      ),
      title: Text(language),
      onTap: () => _changeLanguage(context, locale, langCode),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.change_language_title),
      ),
      body: ListView(
        children: [
          buildCountryTile(
            context,
            langCode: 'en',
            locale: const Locale('en'),
            countryCode: 'US',
            language: 'English',
          ),
          buildCountryTile(
            context,
            langCode: 'es',
            locale: const Locale('es'),
            countryCode: 'ES',
            language: 'Español',
          ),
          buildCountryTile(
            context,
            langCode: 'it',
            locale: const Locale('it'),
            countryCode: 'IT',
            language: 'Italiano',
          ),
          buildCountryTile(
            context,
            langCode: 'zh',
            locale: const Locale('zh'),
            countryCode: 'CN',
            language: '中国人',
          ),
          buildCountryTile(
            context,
            langCode: 'ja',
            locale: const Locale('ja'),
            countryCode: 'JP',
            language: '日本人',
          ),
        ],
      ),
    );
  }
}
