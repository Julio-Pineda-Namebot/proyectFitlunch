import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileItem extends StatelessWidget {
  final String title;
  final String value;
  final Function(BuildContext, String)? onEdit;

  const ProfileItem({
    super.key,
    required this.title,
    required this.value,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value),
      trailing: onEdit != null
        ? IconButton(
            icon: const Icon(FontAwesomeIcons.arrowRight, color: Colors.green),
            onPressed: () => onEdit!(context, value),
          )
        : null, 
    );
  }
}
