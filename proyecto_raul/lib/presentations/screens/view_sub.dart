import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:proyecto_raul/presentations/bloc/subastas/subasta_bloc.dart';
import 'package:proyecto_raul/presentations/bloc/subastas/subastas_event.dart';
import 'package:proyecto_raul/presentations/bloc/subastas/subastas_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewSubInfo extends StatefulWidget {
  final int idSubasta;

  const ViewSubInfo({
    super.key,
    required this.idSubasta,
  });

  @override
  ViewSubInfoState createState() => ViewSubInfoState();
}

class ViewSubInfoState extends State<ViewSubInfo> {
  late String baseUrl;
  late int currentImageIndex;
  late double pujaActual;
  late TextEditingController pujaController;

  @override
  void initState() {
    super.initState();
    baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000';
    currentImageIndex = 0;
    pujaController = TextEditingController();
    context.read<SubastasBloc>().add(FetchSubastasPorIdEvent(widget.idSubasta));
  }

  void handlePujar() async {
    String puja = pujaController.text;
    if (puja.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      if (double.parse(puja) > pujaActual) {
        final email = prefs.getString('email');

        if (email != null) {
          context.read<SubastasBloc>().add(CreateSubastaPujaEvent(
                idPuja: widget.idSubasta,
                email: email,
                puja: puja,
              ));
          // Limpiar el controlador de texto
          pujaController.clear();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No se encontró el email.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('La puja debe ser mayor a la actual.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingresa una cantidad.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<SubastasBloc, SubastasState>(
          builder: (context, state) {
            if (state is SubastasLoadedStateId) {
              return Text(state.subastas.nombre);
            } else if (state is SubastasErrorState) {
              return const Text("Error");
            }
            return const Text('Cargando...');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocListener<SubastasBloc, SubastasState>(
          listener: (context, state) {
            if (state is SubastaCreatedPujaState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Puja realizada con éxito')),
              );
              // Redirigir a la página de subastas después de crear la puja
              context
                  .read<SubastasBloc>()
                  .add(FetchSubastasPorIdEvent(widget.idSubasta));
            } else if (state is SubastasPujaErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No tienes saldo suficiente')),
              );

              context
                  .read<SubastasBloc>()
                  .add(FetchSubastasPorIdEvent(widget.idSubasta));
            }
          },
          child: BlocBuilder<SubastasBloc, SubastasState>(
            builder: (context, state) {
              if (state is SubastasLoadedStateId) {
                pujaActual = state.subastas.pujaActual;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                            image: NetworkImage(
                                '$baseUrl${state.subastas.imagenes[currentImageIndex].url}'),
                            fit: BoxFit.contain,
                            alignment: Alignment.center),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            setState(() {
                              currentImageIndex = (currentImageIndex > 0)
                                  ? currentImageIndex - 1
                                  : state.subastas.imagenes.length - 1;
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward),
                          onPressed: () {
                            setState(() {
                              if (currentImageIndex <
                                  state.subastas.imagenes.length - 1) {
                                currentImageIndex++;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      state.subastas.descripcion,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Finaliza ${(state.subastas.fechaFin).toIso8601String().split('T').first}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 16.0),
                    Center(
                      child: Text(
                        '${state.subastas.pujaActual}€',
                        style: const TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: pujaController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Ingresa la cantidad a pujar',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: handlePujar,
                        icon: const Icon(
                          Icons.monetization_on,
                          color: Colors.black,
                        ),
                        label: Text(
                          'Pujar',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 12.0),
                        ),
                      ),
                    ),
                  ],
                );
              } else if (state is SubastasErrorState) {
                return const Center(
                  child: Text('Error al cargar la información'),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }
}
