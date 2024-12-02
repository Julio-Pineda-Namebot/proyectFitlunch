import 'package:flutter/material.dart';
import 'package:fitlunch/screens/auth/login_screen.dart'; 
import 'package:fitlunch/styles/theme.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_ES', null);
  // Inicializa la clave pública de Stripe
  Stripe.publishableKey = 'pk_test_TYooMQauvdEDq54NiTphI7jx';

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home:
          const LoginScreen(), 
    );
  }
}
