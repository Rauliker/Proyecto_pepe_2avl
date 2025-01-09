import 'package:flutter/material.dart';

typedef FilterCallback = void Function(double? minPrice, double? maxPrice);

void showFiltersDrawer(BuildContext context,
    TextEditingController searchController, FilterCallback onFilterApplied) {
  final TextEditingController minPriceController = TextEditingController();
  final TextEditingController maxPriceController = TextEditingController();

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
                final double? minPrice = minPriceController.text.isNotEmpty
                    ? double.tryParse(minPriceController.text)
                    : null;
                final double? maxPrice = maxPriceController.text.isNotEmpty
                    ? double.tryParse(maxPriceController.text)
                    : null;

                onFilterApplied(minPrice, maxPrice);
                Navigator.pop(context);
              },
              child: Text(
                'Aplicar filtros',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      );
    },
  );
}
