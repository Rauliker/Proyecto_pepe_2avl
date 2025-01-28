import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_raul/presentations/appbars/default_appbar.dart';
import 'package:proyecto_raul/presentations/bloc/subastas/subasta_bloc.dart';
import 'package:proyecto_raul/presentations/bloc/subastas/subastas_event.dart';
import 'package:proyecto_raul/presentations/bloc/subastas/subastas_state.dart';
import 'package:proyecto_raul/presentations/widgets/dialog/error_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

final String _baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000';

class SubEditForm extends StatefulWidget {
  final int idSubasta;
  const SubEditForm({
    super.key,
    required this.idSubasta,
  });

  @override
  SubEditFormState createState() => SubEditFormState();
}

class SubEditFormState extends State<SubEditForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _subInicialController = TextEditingController();
  final TextEditingController _fechaFinController = TextEditingController();
  List<PlatformFile> addedImagenes = [];
  List<PlatformFile> _imagenes = [];
  List<String> deletedImagenes = [];
  String? email = "";
  bool pujas = false;

  @override
  void initState() {
    super.initState();
    _fetchSubData();
  }

  Future<void> _fetchSubData() async {
    context.read<SubastasBloc>().add(FetchSubastasPorIdEvent(widget.idSubasta));
  }

  void _loadSubrData(SubastasLoadedStateId state) {
    _nombreController.text = state.subastas.nombre;
    _descripcionController.text = state.subastas.descripcion;
    _subInicialController.text = state.subastas.pujaInicial;
    _fechaFinController.text =
        (state.subastas.fechaFin).toIso8601String().split('T').first;

    if (state.subastas.pujas != null) {
      pujas = true;
    }

    setState(() {
      _imagenes = state.subastas.imagenes
          .map((imagen) => PlatformFile(
                name: "$_baseUrl${imagen.url}",
                size: 0,
                bytes: null,
              ))
          .toList();
    });
  }

  Future<void> _selectImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (result != null && result.files.isNotEmpty) {
      if (_imagenes.length + result.files.length > 5) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.select_images_error),
          ),
        );
      } else {
        setState(() {
          addedImagenes.addAll(result.files);
          _imagenes.addAll(result.files);
        });
      }
    }
  }

  void _removeImage(int index, String? name) {
    setState(() {
      if (name != null) {
        deletedImagenes.add(name);
      }
      _imagenes.removeAt(index);
    });
  }

  Future<void> showsubDeleteDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.logout_confirmation),
          content: Text(AppLocalizations.of(context)!.delete_auction_quest),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(AppLocalizations.of(context)!.delete),
            ),
          ],
        );
      },
    );

    if (result == true) {
      if (!mounted) return;
      context.read<SubastasBloc>().add(DeleteSubastaEvent(widget.idSubasta));
    }
  }

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

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email');
    if (!mounted) return;
    context.read<SubastasBloc>().add(
          UpdateSubastaEvent(
            id: widget.idSubasta,
            nombre: _nombreController.text.trim(),
            descripcion: _descripcionController.text.trim(),
            fechaFin: _fechaFinController.text.trim(),
            pujaInicial: _subInicialController.text.trim(),
            eliminatedImages: deletedImagenes,
            added: addedImagenes,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(mesage: AppLocalizations.of(context)!.edit_bid),
      body: MultiBlocListener(
        listeners: [
          BlocListener<SubastasBloc, SubastasState>(
            listener: (context, subState) {
              if (subState is SubastaUpdatedState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)!
                        .bid_update_success(email ?? '')),
                  ),
                );
                context.go('/my_sub');
              } else if (subState is SubastasLoadedStateId) {
                _loadSubrData(subState);
              } else if (subState is SubastaDeletedState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        AppLocalizations.of(context)!.bid_delete(email ?? '')),
                  ),
                );
                context.go('/my_sub');
              } else if (subState is SubastasErrorState) {
                ErrorDialog.show(context, subState.message);
              }
            },
          ),
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
                    decoration: InputDecoration(
                        labelText:
                            AppLocalizations.of(context)!.sub_peice_initial),
                    keyboardType: TextInputType.number,
                    enabled: pujas,
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
                  TextButton.icon(
                    onPressed: _selectImage,
                    icon: const Icon(Icons.add_a_photo),
                    label: Text(AppLocalizations.of(context)!.add_image),
                  ),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: _imagenes.map((file) {
                      return Stack(
                        alignment: Alignment.topRight,
                        children: [
                          file.bytes != null
                              ? Image.memory(
                                  file.bytes!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  file.name,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                          IconButton(
                            onPressed: () {
                              if (file.bytes == null) {
                                _removeImage(_imagenes.indexOf(file),
                                    file.name.replaceAll(_baseUrl, ""));
                              } else {
                                _removeImage(_imagenes.indexOf(file), null);
                              }
                            },
                            icon: const Icon(Icons.cancel, color: Colors.red),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text(
                      AppLocalizations.of(context)!.edit,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => showsubDeleteDialog(),
                    child: Text(
                      AppLocalizations.of(context)!.delete,
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
      ),
    );
  }
}
