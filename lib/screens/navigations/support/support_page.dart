import 'package:flutter/material.dart';
import 'package:fitlunch/screens/navigations/support/chat_ai.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});


@override
Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2BC155),
        title: const Text('Soporte', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ListTile(
              title: const Text('CHAT AI'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatPage()),
                );
              },
            ),
            const Spacer(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
