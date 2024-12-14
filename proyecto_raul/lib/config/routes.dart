import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_raul/injection_container.dart' as di;
import 'package:proyecto_raul/presentations/bloc/provincias/prov_bloc.dart';
import 'package:proyecto_raul/presentations/bloc/users/users_bloc.dart';
import 'package:proyecto_raul/presentations/screens/login_screen.dart';
import 'package:proyecto_raul/presentations/screens/singin_screen.dart';
import 'package:proyecto_raul/presentations/screens/spalsh_screen.dart';
import 'package:proyecto_raul/presentations/screens/user_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        builder: (context, state) => BlocProvider(
              create: (context) => di.sl<UserBloc>(),
              child: const HomeScreen(),
            )),
  ],
  redirect: (context, state) async {
    // Verificar si el email está almacenado en SharedPreferences.
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');

    // Si el email existe, redirigir a /home. Si no, a /login.
    if (email != null && email.isNotEmpty) {
      return '/home';
    }

    // Si no está logueado, redirigir a /login.
    return null;
  },
);
