import 'package:flutter/material.dart';
import 'package:fitlunch/page/inicio_page.dart';
import 'package:fitlunch/page/programa_page.dart';
import 'package:fitlunch/page/mispedidos_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitlunch/widgets/user_greeting.dart';
import 'package:fitlunch/widgets/bottom_navigation.dart';
import 'package:fitlunch/utils/animated_switcher.dart';

class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const NavigationExample(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;
  String nombreUsuario = 'Usuario';
  bool isLoading = false;

  final List<Widget> pages = [
    const InicioPage(),
    const ProgramaPage(),
    const MisPedidosPage(),
  ];

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }
  
  Future<void> _loadUserName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nombreUsuario = prefs.getString('name') ?? 'Usuario'; 
    });
  }

  void _changePage(int index) {
    setState(() {
      isLoading = true; 
      currentPageIndex = index;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        isLoading = false; 
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: UserGreeting(userName: nombreUsuario),
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.headset_mic_outlined),
            tooltip: 'Soporte',
            onPressed: () {
              // Acción de soporte
            },
            color: Colors.black,
          ),
          Container(
            height: 24,
            width: 1,
            color: Colors.grey,
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined),
            tooltip: 'Notificaciones',
            onPressed: () {
              // Acción de notificaciones
            },
            color: Colors.black,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: currentPageIndex,
        onItemSelected: _changePage,
      ),
      body: CustomAnimatedSwitcher(
        currentPageIndex: currentPageIndex,
        pages: pages,
        isLoading: isLoading,
      ),
    );
  }
}