import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_raul/presentations/bloc/users/users_bloc.dart';
import 'package:proyecto_raul/presentations/bloc/users/users_event.dart';
import 'package:proyecto_raul/presentations/bloc/users/users_state.dart';
import 'package:proyecto_raul/presentations/widgets/dialog/error_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePassScreen extends StatefulWidget {
  const ChangePassScreen({super.key});

  @override
  State<ChangePassScreen> createState() => _ChangePassScreenState();
}

class _ChangePassScreenState extends State<ChangePassScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();
  final TextEditingController _calleController = TextEditingController();

  final ValueNotifier<bool> _passwordVisible = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _repeatPasswordVisible = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    if (email != null) {
      context.read<UserBloc>().add(UserDataRequest(email: email));
    }
  }

  void _loadUserData(UserLoaded state) {
    _emailController.text = state.user.email;
    _usernameController.text = state.user.username;
  }

  void _submitForm() {
    if (_passwordController.text.isNotEmpty &&
        _repeatPasswordController.text.isNotEmpty &&
        _passwordController.text.length < 6) {
      if (_passwordController.text != _repeatPasswordController.text) {
        ErrorDialog.show(context, 'Las contraseñas deben coincidir.');
      } else {
        ErrorDialog.show(
            context, 'La contraseña debe tener al menos 6 caracteres.');
      }
      return;
    }

    context.read<UserBloc>().add(
          UserUpdatePass(password: _passwordController.text),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cambiar contraseñas')),
      body: MultiBlocListener(
        listeners: [
          BlocListener<UserBloc, UserState>(listener: (context, userState) {
            if (userState is SignupSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Perfil actualizado con éxito')),
              );
              context.go('/home');
            } else if (userState is UserError) {
              ErrorDialog.show(context, userState.message);
            } else if (userState is UserLoaded) {
              _loadUserData(userState);
            }
          }),
        ],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(_emailController.text),
                Text(_usernameController.text),
                const SizedBox(height: 16),
                ValueListenableBuilder<bool>(
                  valueListenable: _passwordVisible,
                  builder: (context, visible, _) {
                    return TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        suffixIcon: IconButton(
                          icon: Icon(
                            visible ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            _passwordVisible.value = !_passwordVisible.value;
                          },
                        ),
                      ),
                      obscureText: !visible,
                    );
                  },
                ),
                const SizedBox(height: 16),
                ValueListenableBuilder<bool>(
                  valueListenable: _repeatPasswordVisible,
                  builder: (context, visible, _) {
                    return TextField(
                      controller: _repeatPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Repetir nueva contraseña',
                        suffixIcon: IconButton(
                          icon: Icon(
                            visible ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            _repeatPasswordVisible.value =
                                !_repeatPasswordVisible.value;
                          },
                        ),
                      ),
                      obscureText: !visible,
                    );
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(
                    'Cambiar contraseña',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.go('/home');
                  },
                  child: const Text('Cancelar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    _calleController.dispose();
    _passwordVisible.dispose();
    _repeatPasswordVisible.dispose();
    super.dispose();
  }
}