import 'dart:async';
import 'package:fitlunch/main.dart';
import 'package:flutter/material.dart';
import 'package:fitlunch/screens/pages/home/home_page.dart';
import 'package:fitlunch/screens/pages/program/program_page.dart';
import 'package:fitlunch/screens/pages/orders/myorders_page.dart';
import 'package:fitlunch/widgets/navigations/user_greeting.dart';
import 'package:fitlunch/widgets/navigations/bottom_navigation.dart';
import 'package:fitlunch/utils/animated_switcher.dart';
import 'package:fitlunch/widgets/navigations/user_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fitlunch/utils/storage_utils.dart';
import 'package:fitlunch/screens/navigations/support/support_page.dart';
import 'package:fitlunch/screens/navigations/notification/notifications.dart';

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
  int currentPageIndex = 1;
  String nombreUsuario = '';
  String emailUsuario = '';
  bool isLoading = false;

  final ValueNotifier<Map<String, String>> _userDetailsNotifier = ValueNotifier({});
  late StreamSubscription<Map<String, String>> _userDetailsSubscription;

  final List<Widget> pages = [
    const ProgramaPage(),
    const InicioPage(),
    const MisPedidosPage(),
  ];

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _userDetailsSubscription = StorageUtils.userDetailsStream.listen((userDetails) {
      setState(() {
        nombreUsuario = userDetails['name'] ?? '';
        emailUsuario = userDetails['email'] ?? '';
      });
    });
  }
  
  @override
  void dispose() {
    _userDetailsSubscription.cancel();
    super.dispose();
  }

  Future<void> _loadUserName() async {
    final userDetails = await StorageUtils.getUserDetails();
    _userDetailsNotifier.value = userDetails;
    setState(() {
      nombreUsuario = userDetails['name']!;
      emailUsuario = userDetails['email']!;
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

  Future<void> logout() async {
    await StorageUtils.clearAll();

    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const MyApp()),
        (route) => false,
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: UserGreeting(userName: nombreUsuario, userEmail: emailUsuario),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.headset),
            tooltip: 'Soporte',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SupportPage()),
              );
            },
            color: Colors.black,
          ),
          Container(
            height: 24,
            width: 1,
            color: Colors.grey,
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.bell),
            tooltip: 'Notificaciones',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationsPage()),
              );
            },
            color: Colors.black,
          ),
        ],
      ),
      drawer: UserDrawer(
        userName: nombreUsuario,
        userEmail: emailUsuario,
        onLogout: logout,
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