import 'package:flutter/material.dart';
import 'package:fitlunch/widgets/profile/profile_item.dart';
import 'package:fitlunch/widgets/profile/profile_action.dart';
import 'package:fitlunch/widgets/profile/edit_modal.dart';
import 'package:fitlunch/utils/storage_utils.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  Map<String, String> profileData = {};

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    profileData = await loadprofile();
    setState(() {});
  }

  void _showEditModal(BuildContext context, String title, String currentValue, {bool isDropdown = false, bool isDate = false}) async {
    final result = await showDialog(
      context: context,
      builder: (context) => EditModal(
        title: title,
        currentValue: currentValue,
        isDropdown: isDropdown,
        isDate: isDate,
      ),
    );

    if (result != null) {
      setState(() {
        profileData[title.toLowerCase()] = result;
      });
      // Guardar el resultado en SharedPreferences o en tu lógica de almacenamiento
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2BC155),
        title: const Text('Perfil', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ProfileItem(
            title: 'Nombres',
            value: profileData['name'] ?? 'Cargando...',
            onEdit: (context, value) => _showEditModal(context, 'Nombres', value),
          ),
          ProfileItem(
            title: 'Apellidos',
            value: profileData['apellido'] ?? 'Cargando...',
            onEdit: (context, value) => _showEditModal(context, 'Apellidos', value),
          ),
          ProfileItem(
            title: 'Dirección de email',
            value: profileData['email'] ?? 'Cargando...',
            onEdit: null,
          ),
          ProfileItem(
            title: 'Sexo',
            value: profileData['sexo'] ?? 'Cargando...',
            onEdit: (context, value) => _showEditModal(context, 'Sexo', value, isDropdown: true),
          ),
          ProfileItem(
            title: 'Fecha de nacimiento',
            value: profileData['fecha_nac'] ?? 'Cargando...',
            onEdit: (context, value) => _showEditModal(context, 'Fecha de nacimiento', value, isDate: true),
          ),
          const Divider(),
          const ProfileAction(title: 'Eliminar cuenta'),
        ],
      ),
    );
  }
}


