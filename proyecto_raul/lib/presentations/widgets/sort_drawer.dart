import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void showSortDrawer(
    BuildContext context,
    void Function(bool isPriceSort, bool isAscending) onSortApplied,
    bool price,
    bool date) {
  bool isPriceSort = true;
  bool isAscending = true;

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
              AppLocalizations.of(context)!.sort,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (price) {
                  price = false;
                } else {
                  price = true;
                }
                isPriceSort = true;
                isAscending = !isAscending;
                onSortApplied(isPriceSort, isAscending);
                Navigator.pop(context);
              },
              child: Text(
                '${AppLocalizations.of(context)!.priceSort} ${price ? AppLocalizations.of(context)!.ascending : AppLocalizations.of(context)!.descending}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (date) {
                  date = false;
                } else {
                  date = true;
                }
                isPriceSort = false;
                isAscending = !isAscending;
                onSortApplied(isPriceSort, isAscending);
                Navigator.pop(context);
              },
              child: Text(
                '${AppLocalizations.of(context)!.dateSort} ${date ? AppLocalizations.of(context)!.ascending : AppLocalizations.of(context)!.descending}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      );
    },
  );
}
