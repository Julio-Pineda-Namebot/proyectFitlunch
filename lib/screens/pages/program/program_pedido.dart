import 'package:flutter/material.dart';
import 'package:fitlunch/screens/auth/address/address_select.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitlunch/widgets/components/flash_message.dart';
import 'package:fitlunch/api/order/orders_api.dart';

class ProgramaPedidoPage extends StatefulWidget {
  final Map<String, dynamic> meal;

  const ProgramaPedidoPage({super.key, required this.meal});

  @override
  State<ProgramaPedidoPage> createState() => ProgramaPedidoPageState();
}

class ProgramaPedidoPageState extends State<ProgramaPedidoPage> {
  String direccion = 'Ubicación no seleccionada';

  @override
  void initState() {
    super.initState();
    _loadSavedAddress();
  }

  // Carga la dirección seleccionada desde SharedPreferences
  Future<void> _loadSavedAddress() async {
    final prefs = await SharedPreferences.getInstance();
    final savedAddress = prefs.getString('selected_address');
    setState(() {
      direccion = savedAddress ?? 'Ubicación no seleccionada';
    });
  }

  // Cambiar dirección
  Future<void> _changeAddress() async {
    final selectedAddress = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddressSelectPage()),
    );
    if (selectedAddress != null) {
      final newAddress =
          '${selectedAddress['tipo_calle']} ${selectedAddress['nombre_calle']} ${selectedAddress['numero'] ?? ''}';
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selected_address', newAddress);
      await prefs.setInt('selected_address_id', selectedAddress['N_ID_DIRECCION']);
      setState(() {
        direccion = newAddress;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Confirmar Pedido'),
        backgroundColor: const Color(0xFF2BC155),
        foregroundColor: Colors.white,
        leading: const BackButton(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Dirección de entrega
            const Text(
              'Dirección de entrega:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildInfoCard(
              icon: Icons.home,
              title: 'Dirección:',
              content: direccion,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _changeAddress,
              child: const Text(
                'Cambiar dirección',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            // Información de la comida
            const Text(
              'Información de la comida:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildMealInfo(widget.meal),
            const SizedBox(height: 16),
            // Botón de confirmar
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2BC155),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () async {
                try {
                  final prefs = await SharedPreferences.getInstance();
                  final selectedAddressId = prefs.getInt('selected_address_id');

                  if (selectedAddressId == null) {
                    throw Exception('Debe seleccionar una dirección válida.');
                  }

                  final orderApi = OrderApi();
                  final response = await orderApi.makeOrder(
                    widget.meal['mealId'],
                    1,
                    selectedAddressId,
                  );
                  
                  if(context.mounted){ 
                    // Muestra un cargador mientras se procesa la solicitud
                    // showDialog(
                    //   context: context,
                    //   barrierDismissible: false,
                    //   builder: (BuildContext context) {
                    //     return const Center(child: CircularProgressIndicator());
                    //   },
                    // );

                    FlashMessage.showSuccess(
                      context,
                      'Pedido realizado con éxito: ${response['message']}',
                    );                 

                    Navigator.pop(context);
                  }
                } catch (e) {
                  if (context.mounted) {
                    Navigator.pop(context);

                    if (e.toString().contains('Error al realizar el pedido: {"message":"Ya has pedido un tipo de comida similar hoy."}')) {
                      FlashMessage.showError(context, 'Ya has pedido un tipo de comida similar hoy.');
                    } else {
                      FlashMessage.showError(context, 'Error al conectar con el servidor: ${e.toString()}');
                    }
                  }
                }
              },
              child: const Text(
                'Confirmar Pedido',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    IconData? icon,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF2BC155), size: 32),
          const SizedBox(width: 12),
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
                  content,
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
    );
  }

  Widget _buildMealInfo(Map<String, dynamic> meal) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              meal['image'] ?? '',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            meal['name'] ?? 'Comida desconocida',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            meal['description'] ?? 'Sin descripción',
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            '${meal['calories'] ?? 'N/A'} Calorías',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
