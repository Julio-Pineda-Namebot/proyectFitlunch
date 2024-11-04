import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, String>> loadUserDetails() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return {
    'name': prefs.getString('name') ?? 'Usuario',
    'email': prefs.getString('email') ?? 'example@gmail.com'
  };
}

Future<String> loadDireccion() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('direccion') ?? 'Ubicación';
}

Future<Map<String, String>> loadprofile() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return {
    'name': prefs.getString('name') ?? 'Usuario',
    'apellido': prefs.getString('apellido') ?? 'Usuario',
    'email': prefs.getString('email') ?? 'example@gmail.com',
    'direccion': prefs.getString('direccion') ?? 'Ubicación',
    'sexo': prefs.getString('sexo') ?? '',
    'fecha_nac': prefs.getString('fecha_nac') ?? '',
    'telefono': prefs.getString('telefono') ?? ''
  };
}