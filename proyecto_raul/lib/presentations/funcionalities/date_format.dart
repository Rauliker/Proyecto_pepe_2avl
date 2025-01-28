import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String getTimeRemaining(DateTime endDate, BuildContext context) {
  final now = DateTime.now();
  final difference = endDate.difference(now);

  final days = difference.inDays;
  final hours = difference.inHours % 24;

  return AppLocalizations.of(context)!.count_action(days, hours);
}
