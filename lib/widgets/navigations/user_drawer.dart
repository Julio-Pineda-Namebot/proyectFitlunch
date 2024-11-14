import 'package:fitlunch/screens/auth/settings/direcction_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fitlunch/screens/about/about_page.dart';
import 'package:fitlunch/screens/auth/settings/profile_page.dart';

class UserDrawer extends StatelessWidget {
  final String userName;
  final String userEmail;
  final VoidCallback onLogout;

  const UserDrawer({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF2BC155)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(FontAwesomeIcons.user, color: Color(0xFF2BC155), size: 30),
                ),
                const SizedBox(height: 10),
                Text(
                  userName,
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  userEmail,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.user),
            title: const Text('Perfil'),
            onTap: () {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
            },
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.mapLocation),
            title: const Text('Direcciones de entrega'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddressListPage()),
              ); 
            },
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.gear),
            title: const Text('Configuración'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.rightFromBracket),
            title: const Text('Cerrar sesión'),
            onTap: onLogout,
          ),
          const Divider(height: 40, thickness: 1),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.circleInfo),
            title: const Text('Acerca de Fitlunch'),
            onTap: (){
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AboutPage()),
            );
            },
          ),
        ],
      ),
    );
  }
}
