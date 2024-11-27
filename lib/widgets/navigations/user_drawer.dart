import 'package:fitlunch/screens/auth/settings/address_page.dart';
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
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF2BC155), 
        ), 
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF2BC155),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: Icon(FontAwesomeIcons.user, color: Color(0xFF2BC155), size: 35),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      userEmail,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14, 
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(FontAwesomeIcons.user, color: Colors.white),
              title: const Text('Mi cuenta', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
              },
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.mapLocation, color: Colors.white),
              title: const Text('Direcciones de entrega', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddressListPage()),
                ); 
              },
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.gear, color: Colors.white),
              title: const Text('Configuración', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.rightFromBracket, color: Colors.white),
              title: const Text('Cerrar sesión', style: TextStyle(color: Colors.white)),
              onTap: onLogout,
            ),

            const SizedBox(height: 280),
            const Divider(height: 10, thickness: 1, color: Colors.white),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: ListTile(
                leading: const Icon(FontAwesomeIcons.circleInfo, color: Colors.white),
                title: const Text('Acerca de Fitlunch', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AboutPage()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
