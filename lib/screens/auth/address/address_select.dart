import 'package:flutter/material.dart';
import 'package:fitlunch/api/auth/settings/api_address.dart';
import 'package:fitlunch/screens/auth/address/address_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitlunch/widgets/components/loading_animation.dart';
import 'package:fitlunch/widgets/components/flash_message.dart';

class AddressSelectPage extends StatefulWidget {
  const AddressSelectPage({super.key});

  @override
  State<AddressSelectPage> createState() => _AddressSelectPageState();
}

class _AddressSelectPageState extends State<AddressSelectPage> {
  final ApiDireccion _apiDireccion = ApiDireccion();
  List<Map<String, dynamic>> _addresses = [];
  bool _isLoading = true;
  String? _errorMessage;
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
    _loadSelectedIndex();
  }

  Future<void> _loadAddresses() async {
    try {
      final addresses = await _apiDireccion.fetchAddresses();
      setState(() {
        _addresses = addresses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar direcciones: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadSelectedIndex() async {
    final prefs = await SharedPreferences.getInstance();
    final savedIndex = prefs.getInt('selected_index');
    if (savedIndex != null) {
      setState(() {
        selectedIndex = savedIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF2BC155),
          foregroundColor: Colors.white,
          leading: const BackButton(color: Colors.white),
        ),
        body: const LottieLoader(isVisible: true),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF2BC155),
          foregroundColor: Colors.white,
          leading: const BackButton(color: Colors.white),
        ),
        body: Center(child: Text(_errorMessage!)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2BC155),
        foregroundColor: Colors.white,
        leading: const BackButton(color: Colors.white),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0,vertical: 15),
              child: Text(
                'Elige donde recibir tu comida Saludable',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 1),
              child: Text(
                'Podras ver costos y tiempos de entrega precisos en las comidas saludables que busques.',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0,vertical: 15),
              child: Text(
                'En una de tus direcciones',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _addresses.length,
                itemBuilder: (context, index) {
                  final address = _addresses[index];
                  final isSelected = index == selectedIndex;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFEDE7F6) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF2BC155) : Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on, color: Color(0xFF2BC155)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${address['tipo_calle'] ?? ''} ${address['nombre_calle'] ?? ''} ${address['numero'] ?? ''}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  '${address['departamento']['nombre']}, ${address['provincia']['nombre']}, ${address['distrito']['nombre']}',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            const Icon(Icons.check_circle, color: Color(0xFF2BC155)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddressListPage()),
                  );    
                },
                child: const Text(
                  'Editar Direcciones',
                  style: TextStyle(
                    color: Colors.blue
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2BC155),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  if (selectedIndex != null) {
                    final selectedAddress = _addresses[selectedIndex!];
                    selectedAddress['index'] = selectedIndex;
                    Navigator.pop(context, selectedAddress);
                  } else {
                    FlashMessage.showError(
                      context,
                      'Por favor, selecciona una dirección',
                    );
                  }
                },
                child: const Text(
                  'Aceptar',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}