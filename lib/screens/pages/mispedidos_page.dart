import 'package:flutter/material.dart';

class MisPedidosPage extends StatelessWidget {
  const MisPedidosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Pedidos'),
      ),
      body: const Center(
        child: Text('Aquí están tus pedidos'),
      ),
    );
  }
}
