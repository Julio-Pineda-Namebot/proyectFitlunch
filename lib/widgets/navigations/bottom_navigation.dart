import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

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
    return CurvedNavigationBar(
      index: 1, 
      height: 52.0,
      backgroundColor: Colors.white, 
      color: const Color(0xFF2BC155), 
      buttonBackgroundColor: const Color(0xFF2BC155), 
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      onTap: onItemSelected, 
      items: const <Widget>[
        FaIcon(FontAwesomeIcons.calendar, color: Colors.white, size: 30), 
        FaIcon(FontAwesomeIcons.house, color: Colors.white, size: 30), 
        FaIcon(FontAwesomeIcons.boxOpen, color: Colors.white, size: 30), 
      ],
    );
  }
}