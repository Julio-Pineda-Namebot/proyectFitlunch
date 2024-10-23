import 'package:flutter/material.dart';

class EditarUsuarioPage extends StatelessWidget {
  const EditarUsuarioPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
      ),
      body: const Center(
        child: Text('Bienvenido a la página de Inicio'),
      ),
    );
  }
}