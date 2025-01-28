import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:proyecto_raul/main.dart';
import 'package:proyecto_raul/presentations/appbars/default_appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeLanguageScreen extends StatefulWidget {
  const ChangeLanguageScreen({super.key});

  @override
  ChangeLanguageScreenState createState() => ChangeLanguageScreenState();
}

class ChangeLanguageScreenState extends State<ChangeLanguageScreen> {
  Future<void> _changeLanguage(Locale locale, String langCode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lang', langCode);

    if (mounted) {
      MyApp.of(context)?.setLocale(locale);
    }
  }

  Widget buildCountryTile({
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
      onTap: () => _changeLanguage(locale, langCode),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
          mesage: AppLocalizations.of(context)!.change_language_title),
      body: ListView(
        children: [
          buildCountryTile(
            langCode: 'en',
            locale: const Locale('en'),
            countryCode: 'US',
            language: 'English',
          ),
          buildCountryTile(
            langCode: 'es',
            locale: const Locale('es'),
            countryCode: 'ES',
            language: 'Español',
          ),
          buildCountryTile(
            langCode: 'it',
            locale: const Locale('it'),
            countryCode: 'IT',
            language: 'Italiano',
          ),
          buildCountryTile(
            langCode: 'fr',
            locale: const Locale('fr'),
            countryCode: 'FR',
            language: 'French',
          ),
          buildCountryTile(
            langCode: 'zh',
            locale: const Locale('zh'),
            countryCode: 'CN',
            language: '中国人',
          ),
          buildCountryTile(
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
