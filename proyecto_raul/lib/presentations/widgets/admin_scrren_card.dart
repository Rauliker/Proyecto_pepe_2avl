import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_raul/presentations/bloc/users/ban_user_bloc.dart';
import 'package:proyecto_raul/presentations/bloc/users/other_user_bloc.dart';
import 'package:proyecto_raul/presentations/bloc/users/users_event.dart';
import 'package:proyecto_raul/presentations/bloc/users/users_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminListWidget extends StatefulWidget {
  final String searchQuery;
  final int roleQuery;
  final bool? bannedQuery;

  const AdminListWidget(
      {super.key,
      required this.searchQuery,
      required this.roleQuery,
      required this.bannedQuery});

  @override
  AdminListWidgetState createState() => AdminListWidgetState();
}

class AdminListWidgetState extends State<AdminListWidget> {
  final List<int> allowedRoles = [2, 1, 0];
  List<String> roleName = ['Admin', 'Empleado', 'Usuario normal'];
  late int roleUser;
  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    roleUser = prefs.getInt('role')!;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OtherUserBloc, UserState>(
      builder: (context, state) {
        if (state is UserOtherLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UserOtherLoaded) {
          final users = state.users.where((user) {
            bool roleMatches = widget.roleQuery == 3
                ? (user.role == 0 || user.role == 1 || user.role == 2)
                : (user.role == widget.roleQuery);
            bool roleDown = roleUser == 0
                ? (user.role == 0 || user.role == 1 || user.role == 2)
                : (user.role == 1 || user.role == 2);
            bool nameOrEmailMatches = user.email
                    .toLowerCase()
                    .contains(widget.searchQuery.toLowerCase()) ||
                user.username
                    .toLowerCase()
                    .contains(widget.searchQuery.toLowerCase());
            bool bannedSeach = widget.bannedQuery != null
                ? (user.banned == widget.bannedQuery)
                : (user.banned == true || user.banned == false);

            return roleMatches && nameOrEmailMatches && roleDown && bannedSeach;
          }).toList();

          if (users.isEmpty) {
            return const Center(
              child: Text("No users found"),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final balance = user.balance;

              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Usuario: ${user.username}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Email: ${user.email}',
                              style: const TextStyle(fontSize: 14.0),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Rol: ${roleName[user.role]}',
                              style: const TextStyle(fontSize: 14.0),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Balance: $balance€',
                              style: const TextStyle(fontSize: 14.0),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Baneado: ${user.banned}',
                              style: const TextStyle(fontSize: 14.0),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          if (roleUser == 0 ||
                              (roleUser == 1 && user.role == 2)) {
                            if (user.banned == true) {
                              context.read<BanUserBloc>().add(UserUpdateBan(
                                  banned: false, email: user.email));
                            } else {
                              context.read<BanUserBloc>().add(UserUpdateBan(
                                  banned: true, email: user.email));
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "No tienes permiso para banear a este usuario."),
                              ),
                            );
                          }
                        },
                        child: BlocBuilder<BanUserBloc, UserState>(
                          builder: (context, state) {
                            if (state is UserBanBanLoading) {
                              return const CircularProgressIndicator(
                                color: Colors.white,
                              );
                            }
                            return user.banned == true
                                ? const Text('Desbanear')
                                : const Text('Banear');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else if (state is UserOtherError) {
          return Center(
            child: Text(state.message),
          );
        } else {
          return const Center(
            child: Text("no se han encontrado usuarios"),
          );
        }
      },
    );
  }
}
