import 'package:flutter/material.dart';
import 'package:fitlunch/widgets/image_carousel.dart';
import 'package:fitlunch/widgets/components/location_section.dart';

class InicioPage extends StatelessWidget {
  const InicioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, 
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Sección de Ubicación
            const LocationSection(),
            // Carrusel de imágenes
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: ImageCarousel(
                imagePaths: [
                  'assets/image/comida_saludable_slide.jpg',
                  'assets/image/comida_saludable_slide2.jpg',
                  'assets/image/comida_saludable_slide3.jpg',
                ],
              ),
            ),

            // Título de la sección
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                'Conoce nuestros planes',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Grid de planes
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(10.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.8,
              ),
              itemCount: plans.length,
              itemBuilder: (context, index) {
                final plan = plans[index];
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(15)),
                        child: Image.asset(
                          plan['image']!,
                          fit: BoxFit.cover,
                          height: 100,
                          width: double.infinity,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              plan['title']!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Updated today',
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
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Datos de ejemplo de los planes
final List<Map<String, String>> plans = [
  {
    'title': 'Plan Económico',
    'image': 'assets/image/comida.jpeg',
  },
  {
    'title': 'Plan Básico',
    'image': 'assets/image/comida2.jpeg',
  },
  {
    'title': 'Plan Intermedio',
    'image': 'assets/image/comida3.jpg',
  },
  {
    'title': 'Plan Avanzado',
    'image': 'assets/image/comida4.jpg',
  },
];
