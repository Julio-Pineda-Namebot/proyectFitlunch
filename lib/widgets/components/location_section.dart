import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fitlunch/screens/auth/settings/address_select.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    _loadSavedAddress();
  }

  
  Future<void> _loadSavedAddress() async {
    final prefs = await SharedPreferences.getInstance();
    final savedAddress = prefs.getString('selected_address');
    if (savedAddress != null) {
      setState(() {
        direccion = savedAddress;
      });
    }
  }

  Future<void> _saveSelectedAddress(String address, int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_address', address);
    await prefs.setInt('selected_index', index);
  }
  
   @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 8.0, right: 8.0, bottom: 8.0),
      child: InkWell(
        onTap: () async {
          final selectedAddress = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddressSelectPage()),
          );

          if (selectedAddress != null) {
            final newAddress =
                '${selectedAddress['tipo_calle']} ${selectedAddress['nombre_calle']} ${selectedAddress['numero'] ?? ''}';
            setState(() {
              direccion = newAddress;
            });
            await _saveSelectedAddress(newAddress, selectedAddress['index']);
          }
        },
        child: Row(
          children: [
            const Icon(FontAwesomeIcons.locationDot, color: Color(0xFF2BC155)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                direccion,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
