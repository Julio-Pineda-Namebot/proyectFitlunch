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

  String fechaNac = prefs.getString('fecha_nac') ?? '';
  if (fechaNac.isNotEmpty) {
    try {
      DateTime fecha = DateTime.parse(fechaNac);
      fechaNac = "${fecha.year}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}";
    } catch (e) {
      ("Error al formatear la fecha: $e");
    }
  }

  return {
    'name': prefs.getString('name') ?? 'Usuario',
    'apellido': prefs.getString('apellido') ?? 'Usuario',
    'email': prefs.getString('email') ?? 'example@gmail.com',
    'direccion': prefs.getString('direccion') ?? 'Ubicación',
    'sexo': prefs.getString('sexo') ?? '',
    'fecha_nac': fechaNac,
    'telefono': prefs.getString('telefono') ?? ''
  };
}

Future<void> saveProfileData(Map<String, String> profileData) async {
  final prefs = await SharedPreferences.getInstance();
  profileData.forEach((key, value) {
    prefs.setString(key, value);
  });
}