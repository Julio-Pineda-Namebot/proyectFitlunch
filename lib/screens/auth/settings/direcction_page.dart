import 'package:fitlunch/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:fitlunch/screens/auth/settings/form_direcction_page.dart';

class AddressListPage extends StatelessWidget {
  AddressListPage({super.key});

  final colorScheme = AppTheme.lightTheme.colorScheme;

  Future<List<Map<String, dynamic>>> fetchAddresses() async {
    // Aquí iría la lógica para traer datos de la base de datos
    await Future.delayed( const Duration(seconds: 2)); // Simula el tiempo de carga
    return [
      {
        'direccion': 'Urb. Las Mercedes B-24 Casa',
        'ciudad': 'Ica - Ica',
        'nombre': 'Julio Nicolas Pineda Sanchez',
        'telefono': '920290851',
        'tags': ['Facturación', 'Domicilio de devoluciones', 'Venta', 'Domicilio de envíos']
      }
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis datos', style: TextStyle(color: Colors.white)),
        backgroundColor: colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
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
              future: fetchAddresses(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text("Error al cargar datos"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No hay direcciones disponibles"));
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DirectionPage()),
                );
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
    );
  }
}

class AddressCard extends StatelessWidget {
  final Map<String, dynamic> address;

  const AddressCard({required this.address});

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
                Icon(Icons.home, size: 32, color: Colors.black),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    address['direccion'] ?? '',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DirectionPage()),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: (address['tags'] as List<String>).map((tag) {
                return Chip(
                  label: Text(tag),
                  backgroundColor: Colors.blue[100],
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            Text(
              address['ciudad'] ?? '',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            const SizedBox(height: 5),
            Text(
              '${address['nombre'] ?? ''} - ${address['telefono'] ?? ''}',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }
}