import 'package:flutter/material.dart';

class FiltrosIncidencias extends StatefulWidget {
  final String? estadoSeleccionado;
  final String? fechaSeleccionada;
  final Function(String, String) onAplicarFiltros;

  const FiltrosIncidencias({
    super.key,
    this.estadoSeleccionado,
    this.fechaSeleccionada,
    required this.onAplicarFiltros,
  });

  @override
  FiltrosIncidenciasState createState() => FiltrosIncidenciasState();
}

class FiltrosIncidenciasState extends State<FiltrosIncidencias> {
  late String estado;
  late String fecha;

  static const List<String> status = [
    'Todos',
    'Creada',
    'En revisión',
    'Rechazada',
    'Completada'
  ];

  @override
  void initState() {
    super.initState();
    estado = widget.estadoSeleccionado ?? status.first;
    fecha = widget.fechaSeleccionada ?? '';
  }

  void _seleccionarFecha() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        fecha = '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filtrar incidencias'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Text('Estado: '),
              Expanded(
                child: DropdownButton<String>(
                  value: estado,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        estado = newValue;
                      });
                    }
                  },
                  items: status.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text('Fecha creación: '),
              Expanded(
                child: TextButton(
                  onPressed: _seleccionarFecha,
                  child: Text(
                    fecha.isNotEmpty ? fecha : 'Seleccionar fecha',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancelar',
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
        TextButton(
          onPressed: () {
            widget.onAplicarFiltros(estado, fecha);
            Navigator.of(context).pop();
          },
          child: Text(
            'Filtrar',
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
      ],
    );
  }
}
