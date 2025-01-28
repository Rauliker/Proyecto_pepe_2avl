import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_raul/presentations/appbars/avatar_appbar.dart';
import 'package:proyecto_raul/presentations/bloc/users/ban_user_bloc.dart';
import 'package:proyecto_raul/presentations/bloc/users/other_user_bloc.dart';
import 'package:proyecto_raul/presentations/bloc/users/users_bloc.dart';
import 'package:proyecto_raul/presentations/bloc/users/users_event.dart';
import 'package:proyecto_raul/presentations/bloc/users/users_state.dart';
import 'package:proyecto_raul/presentations/widgets/admin_scrren_card.dart';
import 'package:proyecto_raul/presentations/widgets/drewers.dart';
import 'package:proyecto_raul/presentations/widgets/filter_users.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  AdminScreenState createState() => AdminScreenState();
}

class AdminScreenState extends State<AdminScreen> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  int roleQuery = 3;
  List<String> roleName = ['Admin', 'Empleado', 'Usuario normal'];
  bool? bannedQuery;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    if (email != null) {
      if (!mounted) return;
      context.read<UserBloc>().add(UserDataRequest(email: email));
      context.read<OtherUserBloc>().add(UserOtherDataRequest(email: email));
    }
  }

  void _filterSubastas(String query, int role, bool? banned) {
    setState(() {
      searchQuery = query;
      roleQuery = role;
      bannedQuery = banned;
    });
  }

  @override
  Widget build(BuildContext context) {
    String filterMessage = '';
    if (searchQuery.isNotEmpty && roleQuery != 3) {
      filterMessage =
          'Filtrado por: nombre o email "$searchQuery" y rol ${roleName[roleQuery]}';
    } else if (searchQuery.isNotEmpty) {
      filterMessage = 'Filtrado por: nombre o email "$searchQuery"';
    } else if (roleQuery != 3) {
      filterMessage = 'Filtrado por: rol ${roleName[roleQuery]}';
    }

    return Scaffold(
      appBar: const AvatarAppBar(),
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: BlocListener<OtherUserBloc, UserState>(
          listener: (context, state) {
            if (state is UserOtherError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: BlocListener<BanUserBloc, UserState>(
            listener: (context, state) {
              if (state is UserBanBanLoaded) {
                fetchUserData();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Operación exitosa')),
                );
              } else if (state is UserBanError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (query) =>
                        _filterSubastas(query, roleQuery, bannedQuery),
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.search,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                if (filterMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      filterMessage,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                Expanded(
                  child: AdminListWidget(
                      searchQuery: searchQuery,
                      roleQuery: roleQuery,
                      bannedQuery: bannedQuery),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return FilterUsersDrawer(
                    onApplyFilters: (roleQuery, bannedQuery) {
                      _filterSubastas(searchQuery, roleQuery, bannedQuery);
                    },
                    roleQuery: roleQuery,
                    bannedQuery: bannedQuery,
                  );
                },
              );
            },
            child: const Icon(Icons.filter_alt),
          ),
          FloatingActionButton(
            onPressed: () {
              context.push('/signup');
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const CustomDrawer(),
    );
  }
}
