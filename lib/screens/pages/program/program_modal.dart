import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:fitlunch/screens/pages/program/program_pedido.dart';
import 'package:fitlunch/widgets/components/flash_message.dart';
import 'package:intl/intl.dart';

void showMealModal(BuildContext context, Map<String, dynamic> meal, String selectedDay) {
  final String imagePath = meal['image'] ?? 'https://via.placeholder.com/150';
  
  final String today = DateFormat.EEEE('es_ES').format(DateTime.now()).toLowerCase();
  final String normalizedSelectedDay = selectedDay.toLowerCase();

  WoltModalSheet.show(
    context: context,
    pageListBuilder: (bottomSheetContext) => [
      SliverWoltModalSheetPage(
        heroImage: Image.network(
          imagePath,
          fit: BoxFit.cover,
          height: 200,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 200,
              color: Colors.grey[300],
              child: const Icon(Icons.image_not_supported, size: 50),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              height: 200,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            );
          },
        ),
        mainContentSliversBuilder: (context) => [
          // Título
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                meal['name'] ?? 'Comida desconocida',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          //Descripcion
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                meal['description'] ?? 'No tiene descripción',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),
          // Calorías
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Text(
                '${meal['calories'] ?? 'N/A'} Calorías',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          ),
          // Botón de pedir
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2BC155),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: normalizedSelectedDay == today
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProgramaPedidoPage(meal: meal),
                          ),
                        );
                      }
                    : () {
                        FlashMessage.showError(
                          context,
                          'Solo puedes pedir comida para el día actual.',
                        );
                      },
                  child: const Text(
                    'Pedir', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                ),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}
