import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_raul/presentations/bloc/subastas/subasta_bloc.dart';
import 'package:proyecto_raul/presentations/bloc/subastas/subastas_event.dart';
import 'package:proyecto_raul/presentations/bloc/subastas/subastas_state.dart';
import 'package:proyecto_raul/presentations/widgets/dialog/error_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubForm extends StatefulWidget {
  const SubForm({super.key});

  @override
  _SubFormState createState() => _SubFormState();
}

class _SubFormState extends State<SubForm> {
  final _formKey = GlobalKey<FormState>();

  // Controladores de los campos
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _SubInicialController = TextEditingController();
  final TextEditingController _fechaFinController = TextEditingController();
  String? email = "";
  List<PlatformFile> _imagenes = [];

  // Método para seleccionar imágenes usando file_picker
  Future<void> _pickImages() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );

      if (result != null) {
        if (_imagenes.length + result.files.length > 5) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Solo se pueden seleccionar hasta 5 imágenes.'),
            ),
          );
        } else {
          setState(() {
            _imagenes.addAll(result.files);
          });
        }
      }
    } catch (e) {
      // print('Error al seleccionar imágenes: $e');
    }
  }

  // Método para mostrar el Date Picker con restricción
  Future<void> _selectDate() async {
    DateTime now = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _fechaFinController.text =
            pickedDate.toIso8601String().split('T').first;
      });
    }
  }

  // Método para enviar datos al servidor
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_imagenes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debe seleccionar al menos una imagen.'),
        ),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email');

    context.read<SubastasBloc>().add(CreateSubastaEvent(
          nombre: _nombreController.text,
          descripcion: _descripcionController.text,
          subInicial: _SubInicialController.text,
          fechaFin: _fechaFinController.text,
          creatorId: email!,
          imagenes: _imagenes,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Crear Sub')),
        body: MultiBlocListener(
          listeners: [
            BlocListener<SubastasBloc, SubastasState>(
                listener: (context, subState) {
              if (subState is SubastaCreatedState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Subasta creado con éxito $email'),
                  ),
                );
                context.go('/mysub');
              } else if (subState is SubastasErrorState) {
                ErrorDialog.show(context, subState.message);
              }
            }),
          ],
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _nombreController,
                      decoration: const InputDecoration(labelText: 'Nombre'),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Por favor ingrese el nombre'
                          : null,
                    ),
                    TextFormField(
                      controller: _descripcionController,
                      decoration:
                          const InputDecoration(labelText: 'Descripción'),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Por favor ingrese la descripción'
                          : null,
                    ),
                    TextFormField(
                      controller: _SubInicialController,
                      decoration:
                          const InputDecoration(labelText: 'Sub Inicial'),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value == null || double.tryParse(value) == null
                              ? 'Por favor ingrese un número válido'
                              : null,
                    ),
                    TextFormField(
                      controller: _fechaFinController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Fecha de Fin',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: _selectDate,
                    ),
                    const SizedBox(height: 10),
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
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: Text(
                        'Crear Sub',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => context.go('/my_sub'),
                      child: Text(
                        'cancelar',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
