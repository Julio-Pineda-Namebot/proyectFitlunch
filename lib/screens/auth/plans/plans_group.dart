import 'package:flutter/material.dart';
import 'package:fitlunch/api/plans/plans_service.dart';

class PlansGroup extends StatefulWidget {
  const PlansGroup({super.key});

  @override
  State<PlansGroup> createState() => PlansGroupState();
}

class PlansGroupState extends State<PlansGroup> {
  final PlansService _plansService = PlansService();
  late Future<List<Map<String, dynamic>>> _plansFuture;

  @override
  void initState() {
    super.initState();
    _plansFuture = _plansService.fetchPlans();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nuestros Planes',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF2BC155), // Color de fondo verde
        foregroundColor: Colors.white, // Texto e íconos blancos
        elevation: 0,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _plansFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green)
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No se encontraron planes.'));
          }

          final plans = snapshot.data!;
          return ListView.builder(
            itemCount: plans.length,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            itemBuilder: (context, index) {
              final plan = plans[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan['X_NOMBRE_PLAN'] ?? 'Sin título',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        plan['X_DESCRIPCION'] ?? 'Sin descripción',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
