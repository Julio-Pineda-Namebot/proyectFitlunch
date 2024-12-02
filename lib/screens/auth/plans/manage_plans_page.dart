import 'package:flutter/material.dart';
import 'package:fitlunch/styles/theme.dart';
import 'package:fitlunch/api/plans/plans_service.dart';
import 'package:fitlunch/widgets/components/flash_message.dart';
import 'package:fitlunch/utils/storage_utils.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage> {
  final colorScheme = AppTheme.lightTheme.colorScheme;
  final PlansService _plansService = PlansService();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  final StorageUtils _storageUtils = StorageUtils(); 

  Future<void> _mostrarModalConfirmacion(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar cancelación'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('¿Estás seguro de que quieres cancelar tu plan?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar', style: TextStyle( color: Colors.green ),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Aceptar', style: TextStyle( color: Colors.green ),),
              onPressed: () async {
                try {
                  await _plansService.cancelarPlan();
                  await _storageUtils.clearPlanId();
                  // Mostrar mensaje de éxito
                  if(context.mounted){
                    FlashMessage.showSuccess(
                      context,
                      'Plan cancelado con éxito',
                    );
                    ValueNotifier<bool> planPurchasedNotifier = ValueNotifier<bool>(false);
                    planPurchasedNotifier.value = false;
                    Navigator.of(context).pop();
                  } 
                } catch (e) {
                  if(context.mounted){
                    FlashMessage.showError(
                      context,
                      'Error al cancelar el plan',
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = AppTheme.lightTheme.colorScheme;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Gestionar Plan',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ListTile(
              leading: Icon(Icons.credit_card, color: Colors.black),
              title: Text(
                'Ver planes disponibles',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.cancel, color: Colors.red),
                      SizedBox(width: 8),
                      Text(
                        'Cancelar plan',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      _mostrarModalConfirmacion(context);
                    },
                    child: const Text('Cancelar', style: TextStyle( color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
