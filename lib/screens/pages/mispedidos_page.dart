import 'package:flutter/material.dart';

class MisPedidosPage extends StatelessWidget {
  const MisPedidosPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Simulamos los datos de los pedidos
    final pedidos = {
      'HOY - 28 DE OCTUBRE': [
        {
          'image': 'assets/image/comida.jpeg',
          'title': 'Ensalada de Fruta',
          'horario': 'Desayuno',
          'calorias': '*',
          'grasas': '*',
        },
        {
          'image': 'assets/image/comida.jpeg',
          'title': 'Ají de gallina',
          'horario': 'Almuerzo',
          'calorias': '*',
          'grasas': '*',
        },
      ],
      'AYER - 27 DE OCTUBRE': [
        {
          'image': 'assets/image/comida.jpeg',
          'title': 'Ensalada de Fruta',
          'horario': 'Desayuno',
          'calorias': '*',
          'grasas': '*',
        },
        {
          'image': 'assets/image/ajidegallina.jpg',
          'title': 'Ají de gallina',
          'horario': 'Almuerzo',
          'calorias': '*',
          'grasas': '*',
        },
      ],
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Pedidos',style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF2BC155),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: pedidos.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título de la sección (Hoy, Ayer, etc.)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      entry.key,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  // Lista de pedidos de la sección
                  Column(
                    children: entry.value.map((pedido) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              // Imagen del pedido
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  pedido['image']!,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Información del pedido
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      pedido['title']!,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Horario: ${pedido['horario']}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      'Calorías: ${pedido['calorias']}  Grasas: ${pedido['grasas']}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
