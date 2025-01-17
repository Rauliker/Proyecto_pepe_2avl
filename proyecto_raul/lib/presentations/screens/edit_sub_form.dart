import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_raul/presentations/bloc/subastas/subasta_bloc.dart';
import 'package:proyecto_raul/presentations/bloc/subastas/subastas_event.dart';
import 'package:proyecto_raul/presentations/bloc/subastas/subastas_state.dart';
import 'package:proyecto_raul/presentations/widgets/dialog/error_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubEditForm extends StatefulWidget {
  final int idSubasta;
  const SubEditForm({
    super.key,
    required this.idSubasta,
  });

  @override
  _SubEditFormState createState() => _SubEditFormState(idSubasta);
}

class _SubEditFormState extends State<SubEditForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _SubInicialController = TextEditingController();
  final TextEditingController _fechaFinController = TextEditingController();
  String? email = "";

  _SubEditFormState(int idSubasta);

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
    _SubInicialController.text = state.subastas.pujaInicial;
    _fechaFinController.text =
        (state.subastas.fechaFin).toIso8601String().split('T').first;
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

  // Método para enviar datos al servidor
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    final prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email');

    context.read<SubastasBloc>().add(
          UpdateSubastaEvent(
            id: widget.idSubasta,
            nombre: _nombreController.text.trim(),
            descripcion: _descripcionController.text.trim(),
            fechaFin: _fechaFinController.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.edit_bid)),
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
                          ? AppLocalizations.of(context)!
                              .description_label_error
                          : null,
                    ),
                    TextFormField(
                      controller: _SubInicialController,
                      decoration: InputDecoration(
                          labelText:
                              AppLocalizations.of(context)!.sub_peice_initial),
                      keyboardType: TextInputType.number,
                      enabled: false,
                    ),
                    TextFormField(
                      controller: _fechaFinController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.date_end,
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: _selectDate,
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
        ));
  }
}
