import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitlunch/main.dart'; 

void main() {
  testWidgets('Prueba de la pantalla de login', (WidgetTester tester) async {
    // Construye la aplicación y desencadena un frame
    await tester.pumpWidget(const MyApp());

    // Verifica que el título esté presente
    expect(find.text('BIENVENIDO'), findsOneWidget);

    // Verifica que los campos de texto estén presentes
    expect(find.byType(TextFormField), findsNWidgets(2));

    // Verifica que el logo esté presente
    expect(find.byType(Image), findsOneWidget);
  });
}
