import 'package:flutter/material.dart';
import 'package:fitlunch/utils/storage_utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LocationSection extends StatefulWidget {
  const LocationSection({super.key});

  @override 
  LocationSectionState createState() => LocationSectionState();
}

class LocationSectionState extends State<LocationSection> {
  String direccion = 'Ubicación';

  @override
  void initState(){
    super.initState();
    _loadDireccion();
  }

  Future<void> _loadDireccion() async{
    final direccionCargada = await loadDireccion();
    setState((){
      direccion = direccionCargada;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 8.0, right: 8.0,bottom: 8.0),
      child: Row(
        children: [
          const Icon(FontAwesomeIcons.locationDot, color: Color(0xFF2BC155)),
          const SizedBox(width: 8),
          Text(
            direccion,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
