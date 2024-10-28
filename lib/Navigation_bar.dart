import 'package:flutter/material.dart';
import 'package:fitlunch/page/inicio_page.dart';
import 'package:fitlunch/page/programa_page.dart';
import 'package:fitlunch/page/mispedidos_page.dart';
import 'package:fitlunch/page/page_appbar/user_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditarUsuarioPage()),
                );
              },
              child: const CircleAvatar(
                backgroundColor: Color(0xFF2BC155),
                child: Icon(Icons.person_outline, color: Colors.white, size: 30),
              ),
            ),
            const SizedBox(width: 10),
            Text('Hola, $nombreUsuario', style: const TextStyle(color: Colors.black)),
          ],
        ),
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
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: const Color.fromARGB(255, 173, 253, 171),
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Inicio',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.calendar_month),
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Programa',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.notifications),
            icon: Icon(Icons.notifications_outlined),
            label: 'Mis pedidos',
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
        child: pages[currentPageIndex],
      ),
    );
  }
}