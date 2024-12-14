import 'package:shared_preferences/shared_preferences.dart';

Future<int> getIdUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int role = prefs.getInt('id_user') ?? 0;
  return role;
}
