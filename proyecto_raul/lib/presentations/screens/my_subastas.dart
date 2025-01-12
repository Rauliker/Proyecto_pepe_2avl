import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_raul/presentations/bloc/subastas/subasta_bloc.dart';
import 'package:proyecto_raul/presentations/bloc/subastas/subastas_event.dart';
import 'package:proyecto_raul/presentations/bloc/users/users_bloc.dart';
import 'package:proyecto_raul/presentations/bloc/users/users_event.dart';
import 'package:proyecto_raul/presentations/bloc/users/users_state.dart';
import 'package:proyecto_raul/presentations/funcionalities/logout.dart';
import 'package:proyecto_raul/presentations/widgets/drewers.dart';
import 'package:proyecto_raul/presentations/widgets/my_sub_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySubsScreen extends StatefulWidget {
  const MySubsScreen({super.key});

  @override
  MySubsScreenState createState() => MySubsScreenState();
}

class MySubsScreenState extends State<MySubsScreen> {
  final String _baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchSubastas();
  }

  void _checkBidEligibility(DateTime fechaFin, int id) {
    DateTime now = DateTime.now();
    if (now.isBefore(fechaFin)) {
      context.go('/edit/$id');
    }
  }

  Future<void> _showLogoutConfirmationDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar'),
          content: const Text('¿Seguro que quieres cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Cerrar sesión'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      await logout(context);
    }
  }

  DateTime now = DateTime.now();

  Future<void> _fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    if (email != null) {
      context.read<UserBloc>().add(UserDataRequest(email: email));
    }
  }

  Future<void> _fetchSubastas() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    context.read<SubastasBloc>().add(FetchSubastasPorUsuarioEvent(email!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('BidHub'),
          leading: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserLoaded) {
                return GestureDetector(
                  onTap: () => Scaffold.of(context).openDrawer(),
                  child: CircleAvatar(
                    backgroundImage: state.user.avatar.isNotEmpty
                        ? NetworkImage('$_baseUrl${state.user.avatar}')
                        : null,
                    child: state.user.avatar.isEmpty
                        ? const Icon(Icons.person, size: 40)
                        : null,
                  ),
                );
              } else {
                return const CircleAvatar(
                  child: Icon(Icons.person),
                );
              }
            },
          ),
        ),
        body: const MySubsBody(),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () => context.go('/create'),
              child: const Icon(Icons.add),
            ),
          ],
        ),
        drawer: const CustomDrawer());
  }
}
