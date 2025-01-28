import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:proyecto_raul/presentations/appbars/default_appbar.dart';
import 'package:proyecto_raul/presentations/widgets/create_user_body.dart';

class SubForm extends StatefulWidget {
  const SubForm({super.key});

  @override
  SubFormState createState() => SubFormState();
}

class SubFormState extends State<SubForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: DefaultAppBar(mesage: AppLocalizations.of(context)!.create_sub),
        body: const MyCreateBody());
  }
}
