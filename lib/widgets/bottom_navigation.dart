import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const BottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      onDestinationSelected: onItemSelected,
      indicatorColor: const Color.fromARGB(255, 173, 253, 171),
      selectedIndex: selectedIndex,
      destinations: const [
        NavigationDestination(
          selectedIcon: FaIcon(FontAwesomeIcons.house),
          icon: FaIcon(FontAwesomeIcons.house),
          label: 'Inicio',
        ),
        NavigationDestination(
          selectedIcon: FaIcon(FontAwesomeIcons.calendar),
          icon: FaIcon(FontAwesomeIcons.calendarDays),
          label: 'Programa',
        ),
        NavigationDestination(
          selectedIcon: FaIcon(FontAwesomeIcons.boxOpen),
          icon: FaIcon(FontAwesomeIcons.box),
          label: 'Mis pedidos',
        ),
      ],
    );
  }
}
