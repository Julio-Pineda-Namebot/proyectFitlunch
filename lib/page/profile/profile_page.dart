import 'package:flutter/material.dart';
import 'package:fitlunch/widgets/profile/profile_item.dart';
import 'package:fitlunch/widgets/profile/profile_action.dart';
import 'package:fitlunch/widgets/profile/edit_modal.dart';
import 'package:fitlunch/utils/storage_utils.dart';
import 'package:fitlunch/api/api_userprofile.dart';
import 'package:fitlunch/widgets/loading_animation.dart';
import 'package:fitlunch/widgets/flash_message.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  Map<String, String> profileData = {};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    profileData = await loadprofile();
    setState(() {});
  }

  Future<void> _updateProfile() async {
    setState(() {
      isLoading = true; 
    });

    try {
      await updateProfile(profileData); 
      await saveProfileData(profileData); 

      await Future.delayed(const Duration(seconds: 1));

      setState(() { 
        isLoading = false; 
        _loadProfileData(); 
      });
      
      if (mounted) {
        FlashMessage.showSuccess(context, 'Perfil actualizado correctamente');
      }
    } catch (e) {
      if (mounted) {
        FlashMessage.showError(context, 'Error al actualizar el perfil');
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false; 
        });
      }
    }
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

    if (result != null && result != currentValue) { 
      setState(() {
        if (title == 'Nombres') {
            profileData['name'] = result;
        } else if (title == 'Apellidos') {
            profileData['apellido'] = result;
        } else if (title == 'Fecha de nacimiento') {
            profileData['fecha_nac'] = result; 
        } else if (title == 'Sexo') {
            profileData['sexo'] = result;
        }
      });

      await _updateProfile(); 
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
      body: Stack(
        children: [
          if (!isLoading)
          ListView(
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
                title: 'Teléfono',
                value: profileData['telefono'] ?? 'Cargando...',
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
          if (isLoading)
            Container(
              color: Colors.white,
              child: const Center(
                child: LottieLoader(isVisible: true),
              ),
            ), 
        ],
      ),
    );
  }
}


