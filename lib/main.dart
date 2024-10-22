import 'package:flutter/material.dart';
import 'package:fitlunch/login_screen.dart'; 

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.green,
        ).copyWith(primary: const Color(0xFF2BC155)),
      ),
      home:
          const LoginScreen(), 
    );
  }
}
