import 'package:fitlunch/main.dart';
import 'package:flutter/material.dart';
import 'package:fitlunch/widgets/profile/profile_item.dart';
import 'package:fitlunch/widgets/profile/edit_modal.dart';
import 'package:fitlunch/utils/storage_utils.dart';
import 'package:fitlunch/api/auth/settings/api_userprofile.dart';
import 'package:fitlunch/widgets/components/loading_animation.dart';
import 'package:fitlunch/widgets/components/flash_message.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  Map<String, String> profileData = {};
  bool isLoading = false;
  final ApiUserprofile apiUserprofile = ApiUserprofile();
  
  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    profileData  = await StorageUtils.getUserDetails();

    // Formatear la fecha si está presente
    if (profileData['fecha_nac'] != null && profileData['fecha_nac']!.isNotEmpty) {
      try {
        DateTime fecha = DateTime.parse(profileData['fecha_nac']!);
        profileData['fecha_nac'] = DateFormat('yyyy-MM-dd').format(fecha);
      } catch (e) {
        // Si no es una fecha válida, establecerla como null o vacía
        profileData['fecha_nac'] = '';
      }
    } else {
      // Si 'fecha_nac' está vacío o nulo, establecerlo explícitamente como vacío
      profileData['fecha_nac'] = '';
    }

    setState(() {});
  }

  Future<void> _updateProfile() async {
    setState(() {
      isLoading = true; 
    });

    try {
      await apiUserprofile.updateProfile(profileData);
      await StorageUtils.saveUserDetails(profileData); 
      await Future.delayed(const Duration(seconds: 1));
      await _loadProfileData();
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

  Future<void> _deleteUser() async {
    setState(() {
      isLoading = true;
    });

    try {
      await apiUserprofile.deleteUser();
      await StorageUtils.clearAll();

      if (mounted) {
          Navigator.of(context).pushAndRemoveUntil( // Change here
            MaterialPageRoute(builder: (context) => const MyApp()), // Change here
            (route) => false,
          );
        }
    } catch (e) {
      if (mounted) {
        FlashMessage.showError(context, 'Error al eliminar la cuenta');
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _showConfirmationModal() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación de cuenta'),
          
content: const Text('¿Estás seguro de que quieres eliminar tu cuenta? Esta acción es irreversible.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar', style: TextStyle(color: Colors.green)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                Navigator.of(context).pop(); 
                await _deleteUser(); 
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2BC155),
        title: const Text('Perfil', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
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
              Container(
                margin: const EdgeInsets.only(top: 16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 8),
                        Text(
                          'Eliminar cuenta',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        await _showConfirmationModal();
                      },
                      child: const Text('Eliminar', style: TextStyle( color:  Colors.white )),
                    ),
                  ],
                ),
              ),
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


