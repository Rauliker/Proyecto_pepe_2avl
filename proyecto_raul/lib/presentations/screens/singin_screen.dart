import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_raul/domain/entities/provincias.dart';
import 'package:proyecto_raul/presentations/bloc/provincias/prov_bloc.dart';
import 'package:proyecto_raul/presentations/bloc/provincias/prov_event.dart';
import 'package:proyecto_raul/presentations/bloc/provincias/prov_state.dart';
import 'package:proyecto_raul/presentations/bloc/users/users_bloc.dart';
import 'package:proyecto_raul/presentations/bloc/users/users_event.dart';
import 'package:proyecto_raul/presentations/bloc/users/users_state.dart';

class CrearUsuarioPage extends StatefulWidget {
  const CrearUsuarioPage({super.key});

  @override
  State<CrearUsuarioPage> createState() => _CrearUsuarioPageState();
}

class _CrearUsuarioPageState extends State<CrearUsuarioPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _calleController = TextEditingController();

  int? _selectedProvincia;
  int? _selectedMunicipio;

  late List<Prov> _provinciasConMunicipios;

  @override
  void initState() {
    super.initState();
    context.read<ProvBloc>().add(ProvDataRequest());
    _provinciasConMunicipios = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Usuario')),
      body: BlocListener<UserBloc, UserState>(
        listener: (context, userState) {
          if (userState is SignupSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      'Usuario creado con éxito: ${userState.user.email}')),
            );
            context.go('/login');
          } else if (userState is SignupFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(userState.message)),
            );
          }
        },
        child: BlocListener<ProvBloc, ProvState>(
          listener: (context, provState) {
            if (provState is ProvLoaded) {
              setState(() {
                _provinciasConMunicipios = provState.provincias;
              });
            } else if (provState is ProvError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(provState.message)),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(labelText: 'Username'),
                  ),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                  ),
                  TextField(
                    controller: _repeatPasswordController,
                    obscureText: true,
                    decoration:
                        const InputDecoration(labelText: 'Repetir Password'),
                  ),
                  DropdownButtonFormField<int>(
                    value: _selectedProvincia,
                    decoration: const InputDecoration(labelText: 'Provincia'),
                    items: _provinciasConMunicipios.map((provincia) {
                      return DropdownMenuItem<int>(
                        value: provincia.idProvincia,
                        child: Text(provincia.nombre),
                      );
                    }).toList(),
                    onChanged: (provinciaId) {
                      setState(() {
                        _selectedProvincia = provinciaId;
                        _selectedMunicipio = null;
                      });
                    },
                  ),
                  DropdownButtonFormField<int>(
                    value: _selectedMunicipio,
                    decoration: const InputDecoration(labelText: 'Municipio'),
                    items: _selectedProvincia != null
                        ? _provinciasConMunicipios
                            .firstWhere(
                              (provincia) =>
                                  provincia.idProvincia == _selectedProvincia,
                              orElse: () => Prov(
                                  idProvincia: 0, nombre: '', localidades: []),
                            )
                            .localidades!
                            .map((municipio) {
                            return DropdownMenuItem<int>(
                              value: municipio.idLocalidad,
                              child: Text(municipio.nombre),
                            );
                          }).toList()
                        : [],
                    onChanged: (municipioId) {
                      setState(() {
                        _selectedMunicipio = municipioId;
                      });
                    },
                  ),
                  TextField(
                    controller: _calleController,
                    decoration: const InputDecoration(labelText: 'Calle'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      final email = _emailController.text.trim();
                      final username = _usernameController.text.trim();
                      final password = _passwordController.text.trim();
                      final repeatPassword =
                          _repeatPasswordController.text.trim();
                      final calle = _calleController.text.trim();

                      if (email.isEmpty ||
                          username.isEmpty ||
                          password.isEmpty ||
                          repeatPassword.isEmpty ||
                          _selectedProvincia == null ||
                          _selectedMunicipio == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Por favor complete todos los campos obligatorios.')),
                        );
                        return;
                      }
                      if (password != repeatPassword) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Las contraseñas no coinciden.')),
                        );
                        return;
                      }
                      // Envía el evento al Bloc
                      context.read<UserBloc>().add(UserCreateRequest(
                            email: email,
                            username: username,
                            password: password,
                            idprovincia: _selectedProvincia!,
                            idmunicipio: _selectedMunicipio!,
                            calle: calle,
                          ));
                    },
                    child: const Text('Crear Usuario'),
                  ),
                  TextButton(
                    onPressed: () {
                      context.go('/login');
                    },
                    child: const Text('Si ya tienes una cuenta, inicia sesión'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    _usernameController.dispose();
    _calleController.dispose();
    super.dispose();
  }
}
