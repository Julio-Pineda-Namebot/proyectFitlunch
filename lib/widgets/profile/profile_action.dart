import 'package:flutter/material.dart';

class ProfileAction extends StatelessWidget {
  final String title;

  const ProfileAction({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward),
      onTap: () {
        
      },
    );
  }
}
