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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<SubastaEntity> _subastas = []; // Lista original de subastas
  List<SubastaEntity> _filteredSubastas = []; // Lista filtrada de subastas
  String _searchQuery = ''; // Texto de búsqueda

  DateTime now = DateTime.now();
  final String _baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000';
  final TextEditingController _searchController = TextEditingController();

  // Para ordenar
  bool _isPriceSortAscending =
      true; // Para saber si estamos ordenando por precio ascendente
  bool _isDateSortAscending = true;
  bool _isPriceSort = false; // Para saber si estamos ordenando por precio
  bool _isDateSort = false; // Para saber si estamos ordenando por fecha

  double? _minPrice;
  double? _maxPrice;
  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchSubastas();
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
    if (email != null) {
      context.read<SubastasBloc>().add(FetchSubastasDeOtroUsuarioEvent(email));
    }
  }

  void _filterSubastas(String query) {
    setState(() {
      _searchQuery = query;
      _filteredSubastas = _subastas.where((subasta) {
        final matchesQuery =
            subasta.nombre.toLowerCase().contains(query.toLowerCase()) ||
                subasta.descripcion.toLowerCase().contains(query.toLowerCase());

        final matchesMinPrice =
            _minPrice == null || subasta.pujaActual >= _minPrice!;
        final matchesMaxPrice =
            _maxPrice == null || subasta.pujaActual <= _maxPrice!;

        return matchesQuery && matchesMinPrice && matchesMaxPrice;
      }).toList();

      // Aplicar ordenamiento si está activado
      if (_isPriceSort) {
        _filteredSubastas.sort((a, b) => _isPriceSortAscending
            ? a.pujaActual.compareTo(b.pujaActual)
            : b.pujaActual.compareTo(a.pujaActual));
      } else if (_isDateSort) {
        _filteredSubastas.sort((a, b) => _isDateSortAscending
            ? a.fechaFin.compareTo(b.fechaFin)
            : b.fechaFin.compareTo(a.fechaFin));
      }
    });
  }

  void _openFilterDrawer() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Drawer(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filtros',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _searchController,
                  onChanged: _filterSubastas,
                  decoration: const InputDecoration(
                    labelText: 'Buscar por nombre o descripción',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Precio mínimo',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    _minPrice =
                        value.isNotEmpty ? double.tryParse(value) : null;
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Precio máximo',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    _maxPrice =
                        value.isNotEmpty ? double.tryParse(value) : null;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _filterSubastas(_searchController.text);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Aplicar filtros',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openSortDrawer() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Drawer(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ordenar',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isPriceSort = true;
                      _isDateSort = false;
                      // Alternar entre ascendente y descendente
                      _isPriceSortAscending = !_isPriceSortAscending;
                      _filterSubastas(
                          _searchController.text); // Actualiza la lista
                    });
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Ordenar por precio ${_isPriceSortAscending ? '↑' : '↓'}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isDateSort = true;
                      _isPriceSort = false;
                      // Alternar entre ascendente y descendente
                      _isDateSortAscending = !_isDateSortAscending;
                      _filterSubastas(
                          _searchController.text); // Actualiza la lista
                    });
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Ordenar por fecha ${_isDateSortAscending ? '↑' : '↓'}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _checkBidEligibility(DateTime fechaFin, int id) {
    DateTime now = DateTime.now();
    if (now.isBefore(fechaFin)) {
      print('Hola');
      context.go('/subastas/$id');
    }
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterSubastas,
                    decoration: const InputDecoration(
                      labelText: 'Buscar por nombre o descripción',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: BlocBuilder<SubastasBloc, SubastasState>(
                    builder: (context, subastasState) {
                      if (subastasState is SubastasLoadingState) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (subastasState is SubastasLoadedState) {
                        _subastas = subastasState.subastas;
                        _filteredSubastas = _subastas.where((subasta) {
                          final matchesQuery = subasta.nombre
                                  .toLowerCase()
                                  .contains(_searchQuery.toLowerCase()) ||
                              subasta.descripcion
                                  .toLowerCase()
                                  .contains(_searchQuery.toLowerCase());

                          final matchesMinPrice = _minPrice == null ||
                              subasta.pujaActual >= _minPrice!;
                          final matchesMaxPrice = _maxPrice == null ||
                              subasta.pujaActual <= _maxPrice!;

                          return matchesQuery &&
                              matchesMinPrice &&
                              matchesMaxPrice;
                        }).toList();

                        if (_isPriceSort) {
                          _filteredSubastas.sort((a, b) => _isPriceSortAscending
                              ? a.pujaActual.compareTo(b.pujaActual)
                              : b.pujaActual.compareTo(a.pujaActual));
                        } else if (_isDateSort) {
                          _filteredSubastas.sort((a, b) => _isDateSortAscending
                              ? a.fechaFin.compareTo(b.fechaFin)
                              : b.fechaFin.compareTo(a.fechaFin));
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.all(8.0),
                          itemCount: _filteredSubastas.length,
                          itemBuilder: (context, index) {
                            final subasta = _filteredSubastas[index];
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
                                                          ? 'Pujar'
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
                                    'Exception: Error al obtener las subastas del usuario: {"message":"No se encontraron pujas de otros usuarios.","error":"Not Found","statusCode":404}'
                                ? 'Error: ${subastasState.message}'
                                : 'No se encontraron subastas.  ',
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
            onPressed: _openFilterDrawer,
            child: const Icon(Icons.filter_list),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _openSortDrawer,
            child: const Icon(Icons.sort),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: InkWell(
          onTap: () => context.go('/my_sub'),
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Mis pujas',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
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
                context.push('/settings');
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
