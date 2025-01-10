import 'package:flutter/material.dart';
import 'package:proyecto_raul/presentations/widgets/dialog/error_dialog.dart';

void showFiltersDrawer(
    BuildContext context,
    TextEditingController searchController,
    void Function(double? minPrice, double? maxPrice) onFilterApplied,
    double? precioMasBajo,
    double? precioMasAlto) {
  final TextEditingController minPriceController = TextEditingController(
    text: precioMasBajo?.toString() ?? '',
  );
  final TextEditingController maxPriceController = TextEditingController(
    text: precioMasAlto?.toString() ?? '',
  );

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filtros',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: minPriceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Precio mínimo',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                if (double.tryParse(value) != null &&
                    double.tryParse(maxPriceController.text) != null) {
                  double min = double.parse(value);
                  double max = double.parse(maxPriceController.text);
                  if (min > max) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'El precio mínimo no puede ser mayor que el máximo')),
                    );
                  }
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: maxPriceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Precio máximo',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final int? minPrice = minPriceController.text.isNotEmpty
                    ? int.tryParse(minPriceController.text)
                    : null;
                final int? maxPrice = maxPriceController.text.isNotEmpty
                    ? int.tryParse(maxPriceController.text)
                    : null;

                if (minPrice == null || maxPrice == null) {
                  ErrorDialog.show(context,
                      'Asegúrese de que los precios sean números válidos y no estén vacíos');
                } else if (minPrice > precioMasAlto!) {
                  ErrorDialog.show(context,
                      'El precio mínimo no puede ser mayor que el precio máximo disponible.');
                } else if (maxPrice < precioMasBajo!) {
                  ErrorDialog.show(context,
                      'El precio máximo no puede ser menor que el precio mínimo disponible.');
                } else if (minPrice > maxPrice) {
                  ErrorDialog.show(context,
                      'El precio mínimo no puede ser mayor que el precio máximo.');
                } else if (minPrice < precioMasBajo) {
                  ErrorDialog.show(context,
                      'El precio mínimo no puede ser menor que $precioMasBajo.');
                } else if (maxPrice > precioMasAlto) {
                  ErrorDialog.show(context,
                      'El precio maximo no puede ser mayor a $precioMasAlto');
                } else {
                  onFilterApplied(minPrice.toDouble(), maxPrice.toDouble());
                  Navigator.pop(context);
                }
              },
              child: Text(
                'Aplicar filtros',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            )
          ],
        ),
      );
    },
  );
}
