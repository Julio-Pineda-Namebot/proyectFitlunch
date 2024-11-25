import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserGreeting extends StatelessWidget {
  final String userName;
  final String userEmail;

  const UserGreeting({super.key, required this.userName, required this.userEmail});
  
  String _formatUserName(String name) {
    if (name.contains(' ')) {
      String firstName = name.split(' ')[0];
      if (firstName.length <= 8) {
        return firstName;
      }
    }
    return name.length > 8 ? '${name.substring(0, 8)}...' : name;
  }


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Scaffold.of(context).openDrawer();
          },
          child: const CircleAvatar(
            backgroundColor: Color(0xFF2BC155),
            child: Icon(FontAwesomeIcons.user, color: Colors.white, size: 20),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          'Hola, ${_formatUserName(userName)}',
          style: const TextStyle(color: Colors.black),
        ),
      ],
    );
  }
}
