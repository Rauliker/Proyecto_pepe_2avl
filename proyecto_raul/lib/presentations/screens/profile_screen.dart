import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_raul/domain/entities/provincias.dart';
import 'package:proyecto_raul/presentations/bloc/provincias/prov_bloc.dart';
import 'package:proyecto_raul/presentations/bloc/provincias/prov_event.dart';
import 'package:proyecto_raul/presentations/bloc/provincias/prov_state.dart';
import 'package:proyecto_raul/presentations/bloc/users/users_bloc.dart';
import 'package:proyecto_raul/presentations/bloc/users/users_event.dart';
import 'package:proyecto_raul/presentations/bloc/users/users_state.dart';
import 'package:proyecto_raul/presentations/widgets/dialog/error_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

final String _baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();
  final TextEditingController _calleController = TextEditingController();

  int? _selectedProvincia;
  int? _selectedMunicipio;
  late List<Prov> _provinciasConMunicipios;
  String _avatarUrl = ''; // URL del avatar
  List<PlatformFile> _imagenes = []; // Para almacenar imágenes seleccionadas

  @override
  void initState() {
    super.initState();
    context.read<ProvBloc>().add(const ProvDataRequest());
    _provinciasConMunicipios = [];
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
    _selectedProvincia = state.user.provincia.idProvincia;
    _selectedMunicipio = state.user.localidad.idLocalidad;
    _calleController.text = state.user.calle;
    _avatarUrl = state.user.avatar;
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
    if (_passwordController.text.isNotEmpty &&
        _passwordController.text.length < 6) {
      ErrorDialog.show(
          context, 'La contraseña debe tener al menos 6 caracteres.');
      return;
    }

    context.read<UserBloc>().add(
          UserUpdateProfile(
            email: _emailController.text,
            username: _usernameController.text,
            idprovincia: _selectedProvincia!,
            idmunicipio: _selectedMunicipio!,
            calle: _calleController.text,
            // images: _imagenes.isNotEmpty ? _imagenes : null,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Perfil')),
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
                CircleAvatar(
                  radius: 40,
                  backgroundImage: _imagenes.isNotEmpty
                      ? MemoryImage(_imagenes[0].bytes!)
                      : _avatarUrl.isNotEmpty
                          ? NetworkImage("$_baseUrl$_avatarUrl")
                          : null,
                  child: _avatarUrl.isEmpty && _imagenes.isEmpty
                      ? const Icon(Icons.person, size: 40)
                      : null,
                ),
                TextButton(
                  onPressed: _pickImages,
                  child: const Text('Cambiar Avatar'),
                ),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  enabled: false,
                ),
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
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
                      _selectedMunicipio =
                          null; // Reset municipio cuando cambia provincia
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
                  onPressed: _submitForm,
                  child: Text(
                    'Guardar Cambios',
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
    super.dispose();
  }
}
