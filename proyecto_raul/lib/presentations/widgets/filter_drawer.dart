import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
            Text(
              AppLocalizations.of(context)!.filters,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: minPriceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.min_price,
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                if (double.tryParse(value) != null &&
                    double.tryParse(maxPriceController.text) != null) {
                  double min = double.parse(value);
                  double max = double.parse(maxPriceController.text);
                  if (min > max) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(AppLocalizations.of(context)!
                              .min_price_greater_than_max_error)),
                    );
                  }
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: maxPriceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.max_price,
                border: const OutlineInputBorder(),
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
                      AppLocalizations.of(context)!.invalid_price_error);
                } else if (minPrice > precioMasAlto!) {
                  ErrorDialog.show(
                      context,
                      AppLocalizations.of(context)!
                          .min_price_greater_than_max_error);
                } else if (maxPrice < precioMasBajo!) {
                  ErrorDialog.show(
                      context,
                      AppLocalizations.of(context)!
                          .max_price_less_than_min_error);
                } else if (minPrice > maxPrice) {
                  ErrorDialog.show(
                      context,
                      AppLocalizations.of(context)!
                          .min_price_greater_than_max_price);
                } else if (minPrice < precioMasBajo) {
                  ErrorDialog.show(
                      context,
                      AppLocalizations.of(context)!
                          .min_price_less_than_min_available(precioMasBajo));
                } else if (maxPrice > precioMasAlto) {
                  ErrorDialog.show(
                      context,
                      AppLocalizations.of(context)!
                          .max_price_greater_than_max_available(precioMasAlto));
                } else {
                  onFilterApplied(minPrice.toDouble(), maxPrice.toDouble());
                  Navigator.pop(context);
                }
              },
              child: Text(
                AppLocalizations.of(context)!.apply_filters,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            )
          ],
        ),
      );
    },
  );
}
