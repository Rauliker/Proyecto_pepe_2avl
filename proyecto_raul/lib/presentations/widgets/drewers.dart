import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_raul/presentations/bloc/users/users_bloc.dart';
import 'package:proyecto_raul/presentations/bloc/users/users_state.dart';
import 'package:proyecto_raul/presentations/funcionalities/logout.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.menu,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 8),
                BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) {
                    if (state is UserLoaded) {
                      return Text(
                        AppLocalizations.of(context)!
                            .menu_hello(state.user.username),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: Text(AppLocalizations.of(context)!.home),
            onTap: () {
              context.go('/home');
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: Text(AppLocalizations.of(context)!.profile),
            onTap: () {
              Navigator.pop(context);
              context.go('/profile');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(AppLocalizations.of(context)!.settings),
            onTap: () {
              Navigator.pop(context);
              context.push('/settings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(AppLocalizations.of(context)!.logout),
            onTap: () async {
              final result = await _showLogoutConfirmationDialog(context);
              if (result == true) {
                if (!context.mounted) return;
                await logout(context);
              }
            },
          ),
        ],
      ),
    );
  }

  Future<bool?> _showLogoutConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.logout),
          content: Text(AppLocalizations.of(context)!.confirm_logout),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(AppLocalizations.of(context)!.logout),
            ),
          ],
        );
      },
    );
  }
}
