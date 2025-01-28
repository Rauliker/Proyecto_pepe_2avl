import 'package:flutter/material.dart';

class FilterUsersDrawer extends StatefulWidget {
  final Function(int roleQuery, bool? bannedQuery) onApplyFilters;
  final int roleQuery;
  final bool? bannedQuery;

  const FilterUsersDrawer({
    super.key,
    required this.onApplyFilters,
    required this.roleQuery,
    required this.bannedQuery,
  });

  @override
  FilterUsersDrawerState createState() => FilterUsersDrawerState();
}

class FilterUsersDrawerState extends State<FilterUsersDrawer> {
  int roleContoller = 3;
  bool? bannedController;

  @override
  void initState() {
    super.initState();
    roleContoller = widget.roleQuery;
    bannedController = widget.bannedQuery;
  }

  void _handleStatusChange(bool? value) {
    setState(() {
      bannedController = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Text(
              'Filter Users',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<int>(
                  value: roleContoller,
                  decoration: const InputDecoration(
                    labelText: "Selecciona el rol",
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 3,
                      child: Text('Todos'),
                    ),
                    DropdownMenuItem(
                      value: 2,
                      child: Text('User'),
                    ),
                    DropdownMenuItem(
                      value: 1,
                      child: Text('Empleado'),
                    ),
                    DropdownMenuItem(
                      value: 0,
                      child: Text('Admin'),
                    ),
                  ],
                  onChanged: (newRole) {
                    setState(() {
                      roleContoller = newRole!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Selecciona el estado del usuario:',
                  style: TextStyle(fontSize: 18),
                ),
                Row(
                  children: [
                    Radio<bool?>(
                      value: null,
                      groupValue: bannedController,
                      onChanged: _handleStatusChange,
                    ),
                    const Text('Todos'),
                  ],
                ),
                Row(
                  children: [
                    Radio<bool>(
                      value: false,
                      groupValue: bannedController,
                      onChanged: _handleStatusChange,
                    ),
                    const Text('No Baneado'),
                  ],
                ),
                Row(
                  children: [
                    Radio<bool>(
                      value: true,
                      groupValue: bannedController,
                      onChanged: _handleStatusChange,
                    ),
                    const Text('Baneado'),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    widget.onApplyFilters(
                      roleContoller,
                      bannedController,
                    );
                    Navigator.pop(context);
                  },
                  child: const Text('Aplicar Filtros'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    widget.onApplyFilters(
                      3,
                      null,
                    );
                    Navigator.pop(context);
                  },
                  child: const Text('Reiniciar'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
