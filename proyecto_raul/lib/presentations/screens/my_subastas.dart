import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_raul/presentations/appbars/avatar_appbar.dart';
import 'package:proyecto_raul/presentations/bloc/subastas/subasta_bloc.dart';
import 'package:proyecto_raul/presentations/bloc/subastas/subastas_event.dart';
import 'package:proyecto_raul/presentations/bloc/users/users_bloc.dart';
import 'package:proyecto_raul/presentations/bloc/users/users_event.dart';
import 'package:proyecto_raul/presentations/widgets/drewers.dart';
import 'package:proyecto_raul/presentations/widgets/my_sub_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySubsScreen extends StatefulWidget {
  const MySubsScreen({super.key});

  @override
  MySubsScreenState createState() => MySubsScreenState();
}

class MySubsScreenState extends State<MySubsScreen> {
  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchSubastas();
  }

  DateTime now = DateTime.now();

  Future<void> _fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    if (email != null) {
      if (!mounted) return;
      context.read<UserBloc>().add(UserDataRequest(email: email));
    }
  }

  Future<void> _fetchSubastas() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    if (!mounted) return;
    context.read<SubastasBloc>().add(FetchSubastasPorUsuarioEvent(email!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AvatarAppBar(),
      body: const MySubsBody(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "btn1",
            onPressed: () => context.go('/create'),
            child: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      bottomNavigationBar: BottomAppBar(
        child: InkWell(
          onTap: () => context.go('/home'),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              AppLocalizations.of(context)!.inicio,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
