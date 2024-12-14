import 'package:intl/intl.dart';

String formatoFecha(String fecha) {
  final DateTime dateTime = DateTime.parse(fecha);
  final DateFormat formatter = DateFormat('dd/MM/yyyy');
  return formatter.format(dateTime);
}
