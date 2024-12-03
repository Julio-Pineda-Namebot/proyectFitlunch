import 'package:flutter/material.dart';
import 'package:fitlunch/screens/navigations/support/chat_ai.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2BC155),
        title: const Text('Soporte', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView( 
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Preguntas Frecuentes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // Pregunta 1
            const ExpansionTile(
              title: Text('¿Cómo puedo cambiar mi plan?'),
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    'Puedes cambiar tu plan desde la sección "CONFIGURACION" en la aplicación. '
                    'Elige el nuevo plan que deseas y sigue las instrucciones.',
                  ),
                ),
              ],
            ),
            // Pregunta 2
            const ExpansionTile(
              title: Text('¿Cuál es la política de reembolso?'),
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    'Para conocer la política de reembolso, consulta la sección "Términos y condiciones" '
                    'o contacta al servicio al cliente.',
                  ),
                ),
              ],
            ),
            // Pregunta 3
            const ExpansionTile(
              title: Text('¿Cómo puedo contactar al servicio al cliente?'),
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    'Puedes contactarnos a través del chat de soporte en la aplicación o enviando un correo a support@fitlunch.com.',
                  ),
                ),
              ],
            ),
            // Pregunta 4
            const ExpansionTile(
              title: Text('¿Qué opciones saludables puedo encontrar en el menú?'),
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    'Nuestro menú incluye opciones saludables como desayunos, ensaladas, almuerzos, cenas, snacks '
                    'comidas bajas en calorías y opciones veganas. Revisa la sección "Programa" '
                    'para más detalles.',
                  ),
                ),
              ],
            ),
            const Divider(),
            // Botón de soporte con FitLunch AI
            Center(
              child: Column(
                children: [
                  const Text(
                    'Fitlunch Asisstant',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2BC155),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ChatPage()),
                      );
                    },
                    child: const Text(
                      'Abrir AI',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
