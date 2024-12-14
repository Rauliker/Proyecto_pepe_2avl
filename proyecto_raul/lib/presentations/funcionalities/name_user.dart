import 'package:shared_preferences/shared_preferences.dart';

Future<String> getEmail() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String nombre = prefs.getString('email') ?? 'Usuario';
  return nombre;
}
