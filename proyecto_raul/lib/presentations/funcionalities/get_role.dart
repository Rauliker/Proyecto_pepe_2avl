import 'package:shared_preferences/shared_preferences.dart';

Future<int> role() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int role = prefs.getInt('role') ?? 2;
  return role;
}
