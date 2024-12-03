import 'package:flutter/material.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2BC155),
        title: const Text(
          'Términos y Condiciones de FitLunch',
          style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Términos y Condiciones de Uso de FitLunch',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Versión vigente: 24 de noviembre de $currentYear',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              const Text(
                'Resumen de términos y condiciones',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'FitLunch es un programa de venta de comida saludable diseñado para ofrecer planes de alimentación a personas que buscan mejorar su estilo de vida a través de opciones nutritivas y balanceadas.',
              ),
              const SizedBox(height: 10),
              const BulletPoint(
                text: 'Los planes de FitLunch permiten seleccionar comidas personalizadas de acuerdo con los objetivos de salud de cada usuario.',
              ),
              const BulletPoint(
                text: 'FitLunch ofrece entregas a domicilio de manera programada, permitiendo que los usuarios reciban sus alimentos frescos y listos para consumir.',
              ),
              const BulletPoint(
                text: 'FitLunch cuenta con diversas opciones de pago para facilitar las transacciones de los usuarios.',
              ),
              const BulletPoint(
                text: 'Además de la venta de alimentos, FitLunch proporciona recursos y recomendaciones nutricionales para apoyar a los usuarios en su camino hacia una vida más saludable.',
              ),
              const BulletPoint(
                text: 'La plataforma de FitLunch está diseñada para ofrecer una experiencia de usuario amigable y segura, protegiendo los datos personales de cada cliente.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;

  const BulletPoint({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 14)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
