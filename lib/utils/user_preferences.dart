import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('name') ?? 'Usuario';
  }
}
