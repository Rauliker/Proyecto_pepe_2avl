import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_raul/presentations/bloc/users/users_bloc.dart';
import 'package:proyecto_raul/presentations/bloc/users/users_event.dart';
import 'package:proyecto_raul/presentations/bloc/users/users_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.appTitleLogin)),
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            context
                .read<UserBloc>()
                .add(UserDataRequest(email: state.user.email));

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(AppLocalizations.of(context)!.loginSuccess)),
            );
            context.go('/home');
            // if (state.user.role == 2) {
            //   context.go('/user');
            // } else {
            //   context.go('/home');
            // }
          } else if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(AppLocalizations.of(context)!
                      .loginFailure(state.message))),
            );
          }
        },
        builder: (context, state) {
          if (state is LoginLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.emailLabel),
                ),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.passwordLabel),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final email = _emailController.text.trim();
                    final password = _passwordController.text.trim();
                    context
                        .read<UserBloc>()
                        .add(LoginRequested(email: email, password: password));
                  },
                  child: Text(
                    AppLocalizations.of(context)!.loginButton,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    context.go('/signup');
                  },
                  child: Text(AppLocalizations.of(context)!.signupPrompt),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
