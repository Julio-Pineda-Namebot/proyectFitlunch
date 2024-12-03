import 'package:fitlunch/api/order/orders_api.dart';
import 'package:fitlunch/screens/pages/program/trackorder/map.dart';
import 'package:flutter/material.dart';

class TrackOrder extends StatefulWidget {
  const TrackOrder ({super.key});

  @override
  TrackOrderState createState() => TrackOrderState();
}

class TrackOrderState extends State<TrackOrder> {
  late Future<List<Map<String, dynamic>>> _ordersFuture;
  final OrderApi _orderApi = OrderApi();

  @override
  void initState() {
    super.initState();
    _ordersFuture = _orderApi.fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2BC155),
        title: const Text(
          'Rastrear Pedidos',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _ordersFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final orders = snapshot.data!.where((order) => order['status'] != 'Completado').toList();
              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return _buildOrderItem(
                    context,
                    order['items'].isNotEmpty ? order['items'][0]['image'] ?? '' : '',
                    order['items'].isNotEmpty ? order['items'][0]['name'] ?? 'Nombre no disponible' : 'Nombre no disponible',
                    order['status'] ?? 'Estado no disponible',
                    _getStatusColor(order['status']),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return const Center(child: CircularProgressIndicator(
                 valueColor: AlwaysStoppedAnimation<Color>(Colors.green)
              ));
            }
          },
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Enruta':
        return Colors.blue;
      case 'Preparando':
        return Colors.amber;
      case 'Completado':
        return Colors.green;
      case 'Cancelado':
        return Colors.red;
      case 'Pendiente':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  Widget _buildOrderItem(
      BuildContext context,String imageUrl, String title, String status, Color statusColor ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            imageUrl.isNotEmpty
              ? Image.network(
                  imageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Manejo de errores de carga de imagen
                    return const Icon(Icons.image, color: Colors.grey);
                  },
                )
              : const Icon(Icons.image, color: Colors.grey),
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
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                // Acción del botón
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyMap()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2BC155), // Fondo verde
                foregroundColor: Colors.white, // Texto blanco
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Ver mapa",
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
