import 'package:flutter/material.dart';

class ProgramaPage extends StatelessWidget {
  const ProgramaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sección de Ubicación
          const Padding(
            padding:  EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(Icons.location_on, color: Color(0xFF2BC155)),
                 SizedBox(width: 8),
                 Text(
                  '*Ubicación*',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          // Botones de Días de la Semana
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildDayButton('Lunes'),
                  _buildDayButton('Martes', isSelected: true),
                  _buildDayButton('Miércoles'),
                  _buildDayButton('Jueves'),
                  _buildDayButton('Viernes'),
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
          _buildMenuItem(
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
          _buildMenuItem(
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

  // Widget para el botón de día
  Widget _buildDayButton(String day, {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? const Color(0xFF2BC155) : Colors.white,
          foregroundColor: isSelected ? Colors.white : Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0xFF2BC155)),
          ),
        ),
        child: Text(day),
      ),
    );
  }

  // Widget para cada elemento del menú
  Widget _buildMenuItem({
    required String imagePath,
    required String title,
    required String calories,
    required String fats,
    required String price,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              imagePath,
              height: 80,
              width: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Calorías: $calories  •  Grasas: $fats',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                Text(
                  'Precio: $price',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
