import 'package:fitlunch/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:fitlunch/screens/auth/address/form_address_page.dart';
import 'package:fitlunch/widgets/components/loading_animation.dart';
import 'package:fitlunch/api/auth/settings/api_address.dart';

class AddressListPage extends StatefulWidget {
  const AddressListPage({super.key});

  @override
  AddressListPageState createState() => AddressListPageState();
}

class AddressListPageState extends State<AddressListPage> {
  final colorScheme = AppTheme.lightTheme.colorScheme;

  final ApiDireccion _apiDireccion = ApiDireccion();

  Future<List<Map<String, dynamic>>>? _addressesFuture;
  
  Future<List<Map<String, dynamic>>> fetchAddresses() async {
    await Future.delayed(const Duration(seconds: 2)); 
    try {
      return await _apiDireccion.fetchAddresses(); 
    } catch (error) {
      return [];
    } 
  }

  void _updateAddressList(){
    if (mounted) {
      setState(() {
        _addressesFuture = fetchAddresses();
      });
    }
  }
  
  @override
  void initState(){
    super.initState();
    _addressesFuture = fetchAddresses();
  }

  Widget _buildNoAddressesView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.home_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16.0),
          const Text(
            'No tienes direcciones',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          const Text(
            'Aún no has agregado ninguna dirección.\nCuando agregues tu primera dirección, aparecerá aquí.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Mis direcciones', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView( 
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Direcciones',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _addressesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const LottieLoader(isVisible: true);
                  } else if (snapshot.hasError) {
                    return const Center(child: Text("Error al cargar datos"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return _buildNoAddressesView();
                  } else {
                    return Column(
                      children: snapshot.data!
                          .map((address) => AddressCard(address: address))
                          .toList(),
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  // Navega a DirectionPage y espera el resultado
                  final result = await Navigator.push( 
                    context,
                    MaterialPageRoute(builder: (context) => const DirectionPage()),
                  );
                  if (result == true) { 
                    setState(() {
                      _updateAddressList();
                    }); 
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  alignment: Alignment.center,
                  child: const Text(
                    'Agregar domicilio',
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}

class AddressCard extends StatelessWidget {
  final Map<String, dynamic> address;

  const AddressCard({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.home, size: 32, color: Colors.black),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '${address['tipo_calle']} ${address['nombre_calle']}, ${address['numero'] ?? 'S/N'}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    final state = context.findAncestorStateOfType<AddressListPageState>();
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DirectionPage(initialData: address),
                      ),
                    );
                    if (result == true && state != null && state.mounted) {
                      state._updateAddressList();
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              '${address['distrito']['nombre']}, ${address['provincia']['nombre']}, ${address['departamento']['nombre']}', 
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            const SizedBox(height: 5),
            Text(
              '${address['nombre']} - ${address['telefono_contacto']}', 
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }
}