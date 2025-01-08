import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_raul/presentations/bloc/users/users_bloc.dart';
import 'package:proyecto_raul/presentations/bloc/users/users_event.dart';
import 'package:proyecto_raul/presentations/bloc/users/users_state.dart';
import 'package:proyecto_raul/presentations/funcionalities/name_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    context.go('/login');
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
      await _logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BidHub'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _showLogoutConfirmationDialog,
          )
        ],
      ),
      body: FutureBuilder<String>(
        future: getEmail(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading user data'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No user data found'));
          } else {
            final userEmail = snapshot.data!;
            context.read<UserBloc>().add(UserDataRequest(email: userEmail));

            return BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is UserLoaded) {
                  var role = "";
                  if (state.user.role == 0) {
                    role = "admin";
                  } else if (state.user.role == 1) {
                    role = "empleado";
                  } else {
                    role = "estandar";
                  }
                  return Center(
                    child: Column(
                      children: [
                        Text('Bienvenido, ${state.user.username}!'),
                        Text('Usuario con rol $role'),
                      ],
                    ),
                  );
                } else if (state is UserError) {
                  return const Center(child: Text('Error loading user data'));
                } else {
                  return const Center(child: Text('No user data found'));
                }
              },
            );
          }
        },
      ),
    );
  }
}
