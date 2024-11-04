import 'package:flutter/material.dart';
import 'package:fitlunch/page/login_screen.dart'; 
import 'package:fitlunch/styles/theme.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home:
          LoginScreen(), 
    );
  }
}