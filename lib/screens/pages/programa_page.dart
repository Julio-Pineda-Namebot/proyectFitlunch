import 'package:flutter/material.dart';
import 'package:fitlunch/widgets/components/location_section.dart';
import 'package:fitlunch/widgets/day_button.dart';
import 'package:fitlunch/widgets/menu_item.dart';

class ProgramaPage extends StatelessWidget {
  const ProgramaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sección de Ubicación
          const LocationSection(),

          // Botones de Días de la Semana
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  DayButton(day: 'Lunes', onPressed: () {}),
                  DayButton(day: 'Martes', isSelected: true, onPressed: () {}),
                  DayButton(day: 'Miércoles', onPressed: () {}),
                  DayButton(day: 'Jueves', onPressed: () {}),
                  DayButton(day: 'Viernes', onPressed: () {}),
                ],
              ),
            ),
          ),

          // Tarjeta de Rastrear Pedido
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(50),
              decoration: BoxDecoration(
                color: const  Color(0xFF7FFF7C),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.motorcycle, color: Colors.white, size: 85),
                   SizedBox(width: 10),
                   Text(
                    'RASTREAR\nPEDIDO',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          // Sección de Almuerzos
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Almuerzos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const MenuItem(
            imagePath: 'assets/image/ajidegallina.jpg',
            title: 'Ají de gallina',
            calories: '*',
            fats: '*',
            price: '*',
          ),
          // Sección de Ensaladas
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Ensaladas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const MenuItem(
            imagePath: 'assets/image/ensalda_rusa.webp',
            title: 'Ensalada rusa',
            calories: '*',
            fats: '*',
            price: '*',
          ),
        ],
      ),
    );
  }
}
