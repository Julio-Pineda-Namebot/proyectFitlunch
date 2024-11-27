import 'package:flutter/material.dart';
import 'package:fitlunch/widgets/components/image_carousel.dart';
import 'package:fitlunch/widgets/components/location_section.dart';
import 'package:fitlunch/api/plans/plans_service.dart';
import 'package:fitlunch/screens/pages/inicio/plan_modal.dart';

class InicioPage extends StatefulWidget {
  const InicioPage({super.key});

  @override
  State<InicioPage> createState() => InicioPageState();
}

class InicioPageState extends State<InicioPage>{
  final PlansService _plansService = PlansService();
  late Future<List<Map<String, dynamic>>> _plansFuture;

  @override
  void initState(){
    super.initState();
    _plansFuture = _plansService.fetchPlans();
  }

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
                  'https://res.cloudinary.com/daioibryi/image/upload/v1732655782/comida_saludable_slide_g18gto.jpg',
                  'https://res.cloudinary.com/daioibryi/image/upload/v1732655787/comida_saludable_slide2_u9ejry.jpg',
                  'https://res.cloudinary.com/daioibryi/image/upload/v1732655789/comida_saludable_slide3_wciwtu.jpg',
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
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _plansFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'No se encontraron planes.',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                final plans = snapshot.data!;
                return GridView.builder(
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
                    return GestureDetector(
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Imagen dinámica
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(15)),
                              child: Image.network(
                                plan['X_IMAGE'] ?? '',
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
                                    plan['X_NOMBRE_PLAN'] ?? 'Sin título',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'S/${plan['N_PRECIO']?.toStringAsFixed(2) ?? '0.00'}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Center(
                                    child: TextButton(
                                      onPressed: () => showPlanModal(context, plan),
                                      style: TextButton.styleFrom(
                                        foregroundColor: const Color(0xFF2BC155),
                                      ),
                                      child: const Text('Ver más'),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
