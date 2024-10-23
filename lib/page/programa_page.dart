import 'package:flutter/material.dart';

class ProgramaPage extends StatelessWidget {
  const ProgramaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Programa'),
      ),
      body: const Center(
        child: Text('Esta es la página del Programa'),
      ),
    );
  }
}
