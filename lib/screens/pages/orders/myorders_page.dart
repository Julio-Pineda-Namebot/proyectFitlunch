import 'package:flutter/material.dart';
import 'package:fitlunch/api/order/orders_api.dart';

class MisPedidosPage extends StatefulWidget {
  const MisPedidosPage({super.key});

  @override
  State<MisPedidosPage> createState() => _MisPedidosPageState();
}

class _MisPedidosPageState extends State<MisPedidosPage> {
  final OrderApi _orderApi = OrderApi();
  late Future<List<dynamic>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = _orderApi.fetchUserOrders();
  }

  Map<String, List<dynamic>> _groupOrdersByDate(List<dynamic> pedidos) {
    final Map<String, List<dynamic>> groupedOrders = {};

    for (var pedido in pedidos) {
      final dateKey = pedido['fechaFormateada'] ?? 'Fecha desconocida';
      if (!groupedOrders.containsKey(dateKey)) {
        groupedOrders[dateKey] = [];
      }
      groupedOrders[dateKey]!.add(pedido);
    }
    return groupedOrders;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _ordersFuture = _orderApi.fetchUserOrders();
          });
        },
        color: Colors.green,
        child: FutureBuilder<List<dynamic>>(
          future: _ordersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green)));
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error al cargar pedidos: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return _buildNoOrdersView();
            }

            final groupedOrders = _groupOrdersByDate(snapshot.data!);

            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: groupedOrders.length, // Número de fechas
              itemBuilder: (context, index) {
                final dateKey = groupedOrders.keys.elementAt(index);
                final pedidosDelDia = groupedOrders[dateKey]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Encabezado de la fecha
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        dateKey,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Pedidos del día
                    ...pedidosDelDia.map((pedido) => _buildPedidoCard(pedido)),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildNoOrdersView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16.0),
          const Text(
            'No tienes pedidos',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          const Text(
            'Aún no has realizado ningún pedido.\nCuando hagas tu primer pedido, aparecerá aquí.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildPedidoCard(dynamic pedido) {
    final estadoPedido = pedido['X_ESTADO_PEDIDO'] ?? 'Desconocido';
    final detallesPedido = pedido['fit_pedido_detalle'] as List<dynamic>? ?? [];

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estado: $estadoPedido',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: estadoPedido == 'Completado' ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 8.0),
            Column(
              children: detallesPedido.map((detalle) {
                final nombreComida =
                    detalle['nombreComida'] ?? 'Comida no especificada';
                final imagenComida = detalle['imagenComida'] ?? '';
                final calorias = detalle['caloriasComida'] ?? 0;
                final horario = detalle['horario'] ?? '';

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Imagen de la comida
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          imagenComida,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.image_not_supported),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      // Información del detalle del pedido
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              nombreComida,
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              'Calorías: $calorias',
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              'Horario: $horario',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
