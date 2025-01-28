import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_raul/presentations/bloc/subastas/subasta_bloc.dart';
import 'package:proyecto_raul/presentations/bloc/subastas/subastas_event.dart';
import 'package:proyecto_raul/presentations/bloc/subastas/subastas_state.dart';
import 'package:proyecto_raul/presentations/widgets/dialog/error_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyCreateBody extends StatefulWidget {
  const MyCreateBody({super.key});

  @override
  MyCreateBodyState createState() => MyCreateBodyState();
}

class MyCreateBodyState extends State<MyCreateBody> {
  final _formKey = GlobalKey<FormState>();

  // Controladores de los campos
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _subInicialController = TextEditingController();
  final TextEditingController _fechaFinController = TextEditingController();
  String? email = "";
  List<PlatformFile> imagenes = [];

  // Método para seleccionar imágenes usando file_picker
  Future<void> _pickImages() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );

      if (result != null) {
        if (imagenes.length + result.files.length > 5) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.select_images_error),
            ),
          );
        } else {
          setState(() {
            imagenes.addAll(result.files);
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

    if (imagenes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.image_error),
        ),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email');
    if (!mounted) return;
    context.read<SubastasBloc>().add(CreateSubastaEvent(
          nombre: _nombreController.text,
          descripcion: _descripcionController.text,
          subInicial: _subInicialController.text,
          fechaFin: _fechaFinController.text,
          creatorId: email!,
          imagenes: imagenes,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SubastasBloc, SubastasState>(
            listener: (context, subState) {
          if (subState is SubastaCreatedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    AppLocalizations.of(context)!.bid_crate_sucess(email!)),
              ),
            );
            context.go('/my_sub');
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
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.name_label),
                  validator: (value) => value == null || value.isEmpty
                      ? AppLocalizations.of(context)!.name_label_error
                      : null,
                ),
                TextFormField(
                  controller: _descripcionController,
                  decoration: InputDecoration(
                      labelText:
                          AppLocalizations.of(context)!.description_label),
                  validator: (value) => value == null || value.isEmpty
                      ? AppLocalizations.of(context)!.description_label_error
                      : null,
                ),
                TextFormField(
                  controller: _subInicialController,
                  decoration: const InputDecoration(labelText: 'Sub Inicial'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null ||
                          int.tryParse(value) == null
                      ? AppLocalizations.of(context)!.sub_peice_initial_error
                      : null,
                ),
                TextFormField(
                  controller: _fechaFinController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.date_end,
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                  onTap: _selectDate,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _pickImages,
                  child: Text(
                    AppLocalizations.of(context)!.select_images,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8.0,
                  children: imagenes.map((file) {
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
                    AppLocalizations.of(context)!.create_sub,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                ElevatedButton(
                  onPressed: () => context.go('/my_sub'),
                  child: Text(
                    AppLocalizations.of(context)!.cancel,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
