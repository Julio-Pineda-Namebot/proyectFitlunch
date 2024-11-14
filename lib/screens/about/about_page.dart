import 'package:flutter/material.dart';
import 'package:fitlunch/screens/about/terms_conditions_page.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});


@override
Widget build(BuildContext context) {
  final currentYear = DateTime.now().year;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2BC155),
        title: const Text('Acerca de FitLunch', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 5),
            const CircleAvatar(
              radius: 90,
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage('assets/splash_green2.png'), 
            ),
            const SizedBox(height: 0),
            const Text(
              'FITLUNCH',
              style: TextStyle(color: Color(0xFF2BC155) , fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Versión 1.0.0', 
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Text(
              'Copyright © $currentYear FitLunch Inc.\nTodos los derechos reservados.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 5),
            const Text(
              'Dirección: Calle Lima #123, Ica, Perú',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const Divider(height: 40, thickness: 1),
            ListTile(
              title: const Text('Términos y Condiciones'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TermsConditionsPage()),
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
