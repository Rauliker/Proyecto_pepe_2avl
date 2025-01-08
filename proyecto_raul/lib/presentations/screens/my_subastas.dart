import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_raul/domain/entities/subastas_entities.dart';
import 'package:proyecto_raul/presentations/bloc/subastas/subasta_bloc.dart';
import 'package:proyecto_raul/presentations/bloc/subastas/subastas_event.dart';
import 'package:proyecto_raul/presentations/bloc/subastas/subastas_state.dart';
import 'package:proyecto_raul/presentations/bloc/users/users_bloc.dart';
import 'package:proyecto_raul/presentations/bloc/users/users_event.dart';
import 'package:proyecto_raul/presentations/bloc/users/users_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySubsScreen extends StatefulWidget {
  const MySubsScreen({super.key});

  @override
  MySubsScreenState createState() => MySubsScreenState();
}

class MySubsScreenState extends State<MySubsScreen> {
  List<SubastaEntity> _subastas = []; // Lista original de subastas
  final String _baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchSubastas();
  }

  void _checkBidEligibility(DateTime fechaFin, int id) {
    DateTime now = DateTime.now();
    if (now.isBefore(fechaFin)) {
      context.go('/edit/$id');
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    context.go('/login');
  }

  Future<void> _showLogoutConfirmationDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar'),
          content: const Text('¿Seguro que quieres cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Cerrar sesión'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      await _logout();
    }
  }

  DateTime now = DateTime.now();

  Future<void> _fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    if (email != null) {
      context.read<UserBloc>().add(UserDataRequest(email: email));
    }
  }

  Future<void> _fetchSubastas() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    context.read<SubastasBloc>().add(FetchSubastasPorUsuarioEvent(email!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BidHub'),
        leading: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoaded) {
              return GestureDetector(
                onTap: () => Scaffold.of(context).openDrawer(),
                child: CircleAvatar(
                  backgroundImage: state.user.avatar.isNotEmpty
                      ? NetworkImage('$_baseUrl${state.user.avatar}')
                      : null,
                  child: state.user.avatar.isEmpty
                      ? const Icon(Icons.person, size: 40)
                      : null,
                ),
              );
            } else {
              return const CircleAvatar(
                child: Icon(Icons.person),
              );
            }
          },
        ),
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserLoaded) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Hola ${state.user.username}, estas son las subastas disponibles:',
                  ),
                ),
                Expanded(
                  child: BlocBuilder<SubastasBloc, SubastasState>(
                    builder: (context, subastasState) {
                      if (subastasState is SubastasLoadingState) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (subastasState is SubastasLoadedState) {
                        // Actualiza la lista de subastas
                        _subastas = subastasState.subastas;

                        return ListView.builder(
                          padding: const EdgeInsets.all(8.0),
                          itemCount: _subastas.length,
                          itemBuilder: (context, index) {
                            final subasta = _subastas[index];
                            int currentImageIndex = 0;

                            return StatefulBuilder(
                              builder: (context, setState) {
                                return Card(
                                  elevation: 4,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Imagen con flechas de navegación
                                        SizedBox(
                                          width: 120,
                                          height: 120,
                                          child: Stack(
                                            children: [
                                              Positioned.fill(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    color: Colors.grey.shade200,
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                          '$_baseUrl${subasta.imagenes[currentImageIndex].url}'),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                left: 0,
                                                top: 0,
                                                bottom: 0,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      currentImageIndex =
                                                          (currentImageIndex >
                                                                  0)
                                                              ? currentImageIndex -
                                                                  1
                                                              : subasta.imagenes
                                                                      .length -
                                                                  1;
                                                    });
                                                  },
                                                  child: Container(
                                                    width: 30,
                                                    color: Colors.black
                                                        .withOpacity(0.3),
                                                    child: const Icon(
                                                        Icons.arrow_back_ios,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                right: 0,
                                                top: 0,
                                                bottom: 0,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      currentImageIndex =
                                                          (currentImageIndex <
                                                                  subasta.imagenes
                                                                          .length -
                                                                      1)
                                                              ? currentImageIndex +
                                                                  1
                                                              : 0;
                                                    });
                                                  },
                                                  child: Container(
                                                    width: 30,
                                                    color: Colors.black
                                                        .withOpacity(0.3),
                                                    child: const Icon(
                                                        Icons.arrow_forward_ios,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 16.0),
                                        // Contenido textual
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                subasta.nombre,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16.0),
                                              ),
                                              const SizedBox(height: 8.0),
                                              Text(
                                                subasta.descripcion,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 8.0),
                                              Text(
                                                'Fecha: ${subasta.fechaFin}',
                                                style: TextStyle(
                                                    color:
                                                        Colors.grey.shade600),
                                              ),
                                              Row(
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      _checkBidEligibility(
                                                          subasta.fechaFin,
                                                          subasta.id);
                                                    },
                                                    child: Text(
                                                      now.isBefore(
                                                              subasta.fechaFin)
                                                          ? 'Editar'
                                                          : 'Fializada',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8.0),
                                                  Text(
                                                    now.isBefore(
                                                            subasta.fechaFin)
                                                        ? ''
                                                        : (subasta.pujas !=
                                                                    null &&
                                                                subasta.pujas!
                                                                    .isNotEmpty)
                                                            ? subasta.pujas!
                                                                .last.emailUser
                                                            : '',
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${subasta.pujaActual}€',
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      } else if (subastasState is SubastasErrorState) {
                        return Center(
                          child: Text(
                            subastasState.message !=
                                    'Exception: {"message":"No se encontraron subastas del usuario de otros usuarios.","error":"Not Found","statusCode":404}'
                                ? 'Error: ${subastasState.message}'
                                : 'No se encontraron subastas del usuario des usuarios.',
                          ),
                        );
                      } else {
                        return const Center(
                            child: Text('No se encontraron subastas'));
                      }
                    },
                  ),
                ),
              ],
            );
          } else if (state is UserError) {
            return const Center(
                child: Text('Error cargando los datos del usuario'));
          } else {
            return const Center(
                child: Text('No se encontraron datos del usuario'));
          }
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => context.go('/create'),
            child: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: Drawer(
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
                  const Text(
                    'Menú',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  BlocBuilder<UserBloc, UserState>(
                    builder: (context, state) {
                      if (state is UserLoaded) {
                        return Text(
                          'Hola, ${state.user.username}',
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
              title: const Text('Inicio'),
              onTap: () {
                context.go('/home');
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Perfil'),
              onTap: () {
                Navigator.pop(context);
                context.go('/profile');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configuración'),
              onTap: () {
                Navigator.pop(context);
                context.go('/settings');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar sesión'),
              onTap: _showLogoutConfirmationDialog,
            ),
          ],
        ),
      ),
    );
  }
}