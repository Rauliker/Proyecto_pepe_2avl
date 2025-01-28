import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_raul/presentations/appbars/default_appbar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          DefaultAppBar(mesage: AppLocalizations.of(context)!.settings_title),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.lock),
            title: Text(AppLocalizations.of(context)!.change_pass),
            onTap: () {
              context.push('/change-password');
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(AppLocalizations.of(context)!.change_language_title),
            onTap: () {
              context.push('/change-language');
            },
          ),
        ],
      ),
    );
  }
}
