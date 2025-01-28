import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_raul/injection_container.dart' as di;
import 'package:proyecto_raul/presentations/bloc/language/language_bloc.dart';
import 'package:proyecto_raul/presentations/bloc/provincias/prov_bloc.dart';
import 'package:proyecto_raul/presentations/bloc/subastas/subasta_bloc.dart';
import 'package:proyecto_raul/presentations/bloc/users/ban_user_bloc.dart';
import 'package:proyecto_raul/presentations/bloc/users/other_user_bloc.dart';
import 'package:proyecto_raul/presentations/bloc/users/users_bloc.dart';
import 'package:proyecto_raul/presentations/screens/admin_screen.dart';
import 'package:proyecto_raul/presentations/screens/change_language_screen.dart';
import 'package:proyecto_raul/presentations/screens/change_password.dart';
import 'package:proyecto_raul/presentations/screens/crear_sub_form.dart';
import 'package:proyecto_raul/presentations/screens/edit_sub_form.dart';
import 'package:proyecto_raul/presentations/screens/login_screen.dart';
import 'package:proyecto_raul/presentations/screens/my_subastas.dart';
import 'package:proyecto_raul/presentations/screens/profile_screen.dart';
import 'package:proyecto_raul/presentations/screens/settings_scrren.dart';
import 'package:proyecto_raul/presentations/screens/singin_screen.dart';
import 'package:proyecto_raul/presentations/screens/spalsh_screen.dart';
import 'package:proyecto_raul/presentations/screens/user_subastas.dart';
import 'package:proyecto_raul/presentations/screens/view_sub.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<int> _getUserRole() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt("role") ?? 2;
}

final GoRouter router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) {
        return const SplashScreen();
      },
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => BlocProvider(
        create: (context) => di.sl<UserBloc>(),
        child: const LoginPage(),
      ),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => di.sl<UserBloc>(),
          ),
          BlocProvider(
            create: (context) => di.sl<ProvBloc>(),
          ),
        ],
        child: const CrearUsuarioPage(),
      ),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) {
        return FutureBuilder<int>(
          future: _getUserRole(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text("Error loading role"));
            }
            final role = snapshot.data ?? 2;
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => di.sl<UserBloc>(),
                ),
                BlocProvider(
                  create: (context) => di.sl<OtherUserBloc>(),
                ),
                BlocProvider(
                  create: (context) => di.sl<SubastasBloc>(),
                ),
                BlocProvider(create: (context) => di.sl<BanUserBloc>())
              ],
              child: role == 2 ? const HomeScreen() : const AdminScreen(),
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/my_sub',
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => di.sl<UserBloc>(),
          ),
          BlocProvider(
            create: (context) => di.sl<SubastasBloc>(),
          ),
        ],
        child: const MySubsScreen(),
      ),
    ),
    GoRoute(
      path: '/create',
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => di.sl<UserBloc>(),
          ),
          BlocProvider(
            create: (context) => di.sl<SubastasBloc>(),
          ),
        ],
        child: const SubForm(),
      ),
    ),
    GoRoute(
      path: '/edit/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'];
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => di.sl<UserBloc>(),
            ),
            BlocProvider(
              create: (context) => di.sl<SubastasBloc>(),
            ),
          ],
          child: SubEditForm(idSubasta: int.parse(id!)),
        );
      },
    ),
    GoRoute(
      path: '/subastas/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'];
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => di.sl<UserBloc>(),
            ),
            BlocProvider(
              create: (context) => di.sl<SubastasBloc>(),
            ),
          ],
          child: ViewSubInfo(idSubasta: int.parse(id!)),
        );
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => di.sl<UserBloc>(),
          ),
          BlocProvider(
            create: (context) => di.sl<ProvBloc>(),
          ),
        ],
        child: const ProfileScreen(),
      ),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => BlocProvider(
        create: (context) => di.sl<UserBloc>(),
        child: const SettingsScreen(),
      ),
    ),
    GoRoute(
      path: '/change-language',
      builder: (context, state) => BlocProvider(
        create: (context) => di.sl<LanguageBloc>(),
        child: const ChangeLanguageScreen(),
      ),
    ),
    GoRoute(
      path: '/change-password',
      builder: (context, state) => BlocProvider(
        create: (context) => di.sl<UserBloc>(),
        child: const ChangePassScreen(),
      ),
    ),
  ],
  redirect: (context, state) async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final role = prefs.getInt('role');
    if (state.matchedLocation == '/splash') {
      if (email != null && email.isNotEmpty) {
        return '/home';
      }
      return '/login';
    }

    if (email != null && email.isNotEmpty) {
      if (role == 1 || role == 0) {
        if (state.matchedLocation == '/signup') {
          return '/signup';
        }
      } else if (state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup') {
        return '/home';
      }
      return null;
    }

    if (state.matchedLocation != '/login' &&
        state.matchedLocation != '/signup') {
      return '/login';
    }

    return null;
  },
);
