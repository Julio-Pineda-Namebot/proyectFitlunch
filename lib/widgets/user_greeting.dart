// user_greeting.dart
import 'package:flutter/material.dart';
import 'package:fitlunch/page/user/user_page.dart';

class UserGreeting extends StatelessWidget {
  final String userName;

  const UserGreeting({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EditarUsuarioPage()),
            );
          },
          child: const CircleAvatar(
            backgroundColor: Color(0xFF2BC155),
            child: Icon(Icons.person_outline, color: Colors.white, size: 30),
          ),
        ),
        const SizedBox(width: 10),
        Text('Hola, $userName', style: const TextStyle(color: Colors.black)),
      ],
    );
  }
}
