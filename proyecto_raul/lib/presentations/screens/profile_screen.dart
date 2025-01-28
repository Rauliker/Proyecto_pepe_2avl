import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:proyecto_raul/presentations/appbars/default_appbar.dart';
import 'package:proyecto_raul/presentations/widgets/update_user_body.dart';

final String baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            DefaultAppBar(mesage: AppLocalizations.of(context)!.profile_update),
        body: const UpdateUserBody());
  }
}
