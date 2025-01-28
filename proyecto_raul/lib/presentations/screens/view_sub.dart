import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:proyecto_raul/domain/entities/subastas_entities.dart';
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
  late int pujaActual;
  late TextEditingController pujaController;
  late bool isAuto = false;

  late TextEditingController incrementController =
      TextEditingController(text: "0");

  late TextEditingController maxAutoController =
      TextEditingController(text: "0");
  String? email;

  bool hasLoaded = false; // Bandera para evitar la ejecución repetida

  @override
  void initState() {
    super.initState();
    baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000';
    currentImageIndex = 0;
    pujaController = TextEditingController();
    loadData();
  }

  void winners(List<Puja>? pujas) async {
    if (pujas == null || pujas.isEmpty) {
      isAuto = false;
    } else {
      // Encuentra la puja más reciente.
      final Puja latestPuja =
          pujas.where((puja) => puja.emailUser == email).first;

      isAuto = latestPuja.isAuto;
      incrementController =
          TextEditingController(text: "${latestPuja.increment}");
      maxAutoController =
          TextEditingController(text: "${latestPuja.maxAutoBid}");
    }
  }

  void handlePujar() async {
    String puja = pujaController.text;
    if (puja.isNotEmpty) {
      if (double.parse(puja) > pujaActual) {
        if (email != null) {
          if (!mounted) return;
          context.read<SubastasBloc>().add(CreateSubastaPujaEvent(
              idPuja: widget.idSubasta,
              email: email!,
              puja: puja,
              isAuto: isAuto,
              incrementController: incrementController.text,
              maxAutoController: maxAutoController.text));
          // Limpiar el controlador de texto
          pujaController.clear();
        } else {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No se encontró el email.')),
          );
        }
      } else {
        if (!mounted) return;
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

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email');
    if (!mounted) return;
    context.read<SubastasBloc>().add(FetchSubastasPorIdEvent(widget.idSubasta));

    context.read<SubastasBloc>().stream.listen((state) {
      if (state is SubastasLoadedStateId) {
        var pujaData = state.subastas.pujas
            ?.where((puja) => puja.emailUser == email)
            .first;
        if (pujaData != null) {
          setState(() {
            isAuto = pujaData.isAuto;
            incrementController.text = pujaData.increment.toString();
            maxAutoController.text = pujaData.maxAutoBid.toString();
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<SubastasBloc, SubastasState>(
          builder: (context, state) {
            if (state is SubastasLoadedStateId) {
              if (!hasLoaded) {
                // Solo se ejecuta una vez
                winners(state.subastas.pujas);
                hasLoaded = true; // Marcar como cargado
              }
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

                return SingleChildScrollView(
                  child: Column(
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
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
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
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.ingrese,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Checkbox(
                            value: isAuto,
                            onChanged: (bool? value) {
                              setState(() {
                                isAuto = value ?? false;
                                print(isAuto);
                              });
                            },
                          ),
                          Text(AppLocalizations.of(context)!.auto_bid_check),
                        ],
                      ),
                      if (isAuto == true) ...[
                        const SizedBox(height: 16.0),
                        TextField(
                          controller: incrementController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText:
                                AppLocalizations.of(context)!.auto_bid_cant,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        TextField(
                          controller: maxAutoController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText:
                                AppLocalizations.of(context)!.auto_bid_max_cant,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ],
                      const SizedBox(height: 16.0),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: handlePujar,
                          icon: const Icon(
                            Icons.monetization_on,
                            color: Colors.black,
                          ),
                          label: Text(
                            AppLocalizations.of(context)!.bid,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 12.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else if (state is SubastasErrorState) {
                return Center(
                  child: Text(AppLocalizations.of(context)!.error),
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
