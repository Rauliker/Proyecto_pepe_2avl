import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
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
import 'package:proyecto_raul/presentations/widgets/dialog/error_dialog.dart';

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
  List<PlatformFile> _imagenes = [];

  int? _selectedProvincia;
  int? _selectedMunicipio;
  late List<Prov> _provinciasConMunicipios;

  @override
  void initState() {
    super.initState();
    context.read<ProvBloc>().add(const ProvDataRequest());
    _provinciasConMunicipios = [];
  }

  Future<void> _pickImages() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null) {
        setState(() {
          _imagenes = result.files;
        });
      }
    } catch (e) {
      ErrorDialog.show(context, 'Error al seleccionar imágenes: $e');
    }
  }

  void _submitForm() {
    if (_passwordController.text.isEmpty ||
        _passwordController.text.length < 6 ||
        _passwordController.text != _repeatPasswordController.text ||
        _selectedProvincia == null ||
        _selectedMunicipio == null) {
      String errorMessage = '';
      if (_passwordController.text.isEmpty ||
          _selectedProvincia == null ||
          _selectedMunicipio == null) {
        errorMessage = 'Por favor complete todos los campos.';
      } else if (_passwordController.text.length < 6) {
        errorMessage = 'La contraseña debe tener al menos 6 caracteres.';
      } else if (_passwordController.text != _repeatPasswordController.text) {
        errorMessage = 'Las contraseñas no coinciden.';
      }
      ErrorDialog.show(context, errorMessage);
      return;
    }

    context.read<UserBloc>().add(
          UserCreateRequest(
              email: _emailController.text,
              password: _passwordController.text,
              username: _usernameController.text,
              imagen: _imagenes,
              idprovincia: _selectedProvincia!,
              idmunicipio: _selectedMunicipio!,
              calle: _calleController.text),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Usuario')),
      body: MultiBlocListener(
        listeners: [
          BlocListener<UserBloc, UserState>(listener: (context, userState) {
            if (userState is SignupSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text('Usuario creado con éxito: ${userState.user.email}'),
                ),
              );
              context.go('/login');
            } else if (userState is SignupFailure) {
              ErrorDialog.show(context, userState.message);
            }
          }),
          BlocListener<ProvBloc, ProvState>(listener: (context, provState) {
            if (provState is ProvLoaded) {
              setState(() {
                _provinciasConMunicipios = provState.provincias;
              });
            } else if (provState is ProvError) {
              ErrorDialog.show(context, provState.message);
            }
          }),
        ],
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
                  onPressed: _pickImages,
                  child: Text(
                    'Seleccionar Imágenes',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8.0,
                  children: _imagenes.map((file) {
                    return kIsWeb
                        ? Image.memory(file.bytes!,
                            height: 50, width: 50, fit: BoxFit.cover)
                        : Text(file.name);
                  }).toList(),
                ),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(
                    'Crear Usuario',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
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
