import 'package:flutter/material.dart';

class SettingNotifications extends StatefulWidget {
  const SettingNotifications({super.key});

  @override
  State<SettingNotifications> createState() => _SettingNotificationsState();
}

class _SettingNotificationsState extends State<SettingNotifications> {
  bool _isNotificationsEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ajustes de notificaciones',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF2BC155),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recibir notificaciones',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            Switch(
              value: _isNotificationsEnabled,
              onChanged: (bool value) {
                setState(() {
                  _isNotificationsEnabled = value;
                });
              },
              activeColor: Colors.green,
              activeTrackColor: Colors.green.shade200,
            ),
          ],
        ),
      ),
    );
  }
}
