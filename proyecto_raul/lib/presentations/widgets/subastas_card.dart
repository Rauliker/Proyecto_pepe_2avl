import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_raul/presentations/bloc/subastas/subasta_bloc.dart';
import 'package:proyecto_raul/presentations/bloc/subastas/subastas_state.dart';

class SubastasListWidget extends StatefulWidget {
  final String searchQuery;
  final double? minPrice;
  final double? maxPrice;
  final bool isPriceSort;
  final bool isPriceSortAscending;
  final bool isDateSort;
  final bool isDateSortAscending;

  const SubastasListWidget({
    Key? key,
    required this.searchQuery,
    this.minPrice,
    this.maxPrice,
    required this.isPriceSort,
    required this.isPriceSortAscending,
    required this.isDateSort,
    required this.isDateSortAscending,
  }) : super(key: key);

  @override
  _SubastasListWidgetState createState() => _SubastasListWidgetState();
}

class _SubastasListWidgetState extends State<SubastasListWidget> {
  final String _baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000';
  bool _isFirstTimeSortedPrice = true;
  bool _isFirstTimeSortedDate = true;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubastasBloc, SubastasState>(
      builder: (context, state) {
        if (state is SubastasLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SubastasLoadedState) {
          // Filtrar las subastas
          final subastas = state.subastas.where((subasta) {
            final matchesQuery = subasta.nombre
                    .toLowerCase()
                    .contains(widget.searchQuery.toLowerCase()) ||
                subasta.descripcion
                    .toLowerCase()
                    .contains(widget.searchQuery.toLowerCase());

            final matchesMinPrice = widget.minPrice == null ||
                subasta.pujaActual >= widget.minPrice!;
            final matchesMaxPrice = widget.maxPrice == null ||
                subasta.pujaActual <= widget.maxPrice!;

            return matchesQuery && matchesMinPrice && matchesMaxPrice;
          }).toList();

          if (widget.isPriceSort) {
            if (_isFirstTimeSortedPrice) {
              _isFirstTimeSortedPrice = false;

              subastas.sort((a, b) {
                return widget.isPriceSortAscending
                    ? b.pujaActual.compareTo(a.pujaActual)
                    : a.pujaActual.compareTo(b.pujaActual);
              });
            } else {
              _isFirstTimeSortedPrice = true;
              subastas.sort((a, b) {
                return widget.isPriceSortAscending
                    ? a.pujaActual.compareTo(b.pujaActual)
                    : b.pujaActual.compareTo(a.pujaActual);
              });
            }
          } else if (widget.isDateSort) {
            if (_isFirstTimeSortedDate) {
              _isFirstTimeSortedDate = false;

              subastas.sort((a, b) {
                return widget.isDateSortAscending
                    ? b.fechaFin.compareTo(a.fechaFin)
                    : a.fechaFin.compareTo(b.fechaFin);
              });
            } else {
              _isFirstTimeSortedDate = true;
              subastas.sort((a, b) {
                return widget.isDateSortAscending
                    ? a.fechaFin.compareTo(b.fechaFin)
                    : b.fechaFin.compareTo(a.fechaFin);
              });
            }
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: subastas.length,
            itemBuilder: (context, index) {
              final subasta = subastas[index];
              int currentImageIndex = 0;

              return StatefulBuilder(
                builder: (context, setState) {
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
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
                                            (currentImageIndex > 0)
                                                ? currentImageIndex - 1
                                                : subasta.imagenes.length - 1;
                                      });
                                    },
                                    child: Container(
                                      width: 30,
                                      color: Colors.black.withOpacity(0.3),
                                      child: const Icon(Icons.arrow_back_ios,
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
                                        currentImageIndex = (currentImageIndex <
                                                subasta.imagenes.length - 1)
                                            ? currentImageIndex + 1
                                            : 0;
                                      });
                                    },
                                    child: Container(
                                      width: 30,
                                      color: Colors.black.withOpacity(0.3),
                                      child: const Icon(Icons.arrow_forward_ios,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    DateTime now = DateTime.now();
                                    if (now.isBefore(subasta.fechaFin)) {
                                      context.push('/subastas/${subasta.id}');
                                    }
                                  },
                                  child: Text(
                                    DateTime.now().isBefore(subasta.fechaFin)
                                        ? 'Pujar'
                                        : 'Finalizada',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${subasta.pujaActual}€',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
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
        } else if (state is SubastasErrorState) {
          return Center(
            child: Text('Error: ${state.message}'),
          );
        } else {
          return const Center(child: Text('No se encontraron subastas.'));
        }
      },
    );
  }
}
