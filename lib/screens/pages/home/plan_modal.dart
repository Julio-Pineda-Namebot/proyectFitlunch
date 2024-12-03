// import 'package:fitlunch/screens/navigations/notification/service_notifications.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:fitlunch/widgets/components/image_carousel.dart';
import 'package:fitlunch/api/payment/payment_api.dart';
import 'package:fitlunch/widgets/components/flash_message.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void showPlanModal(BuildContext context, Map<String, dynamic> plan,VoidCallback onPlanPurchased,) async{
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final storedPlanId = await secureStorage.read(key: 'plan_id');
  final isSubscribed = storedPlanId != null && int.tryParse(storedPlanId) == plan['N_ID_PLAN'];
  final isSubscribedToAnyPlan = storedPlanId != null;
  
  final List<String> imagePaths = (plan['fit_images'] as List<dynamic>?)
          ?.map((image) => image['X_URL'] as String)
          .toList() ??
      [];

  if (!context.mounted) return;
  
  WoltModalSheet.show(
    context: context,
    pageListBuilder: (bottomSheetContext) => [
      SliverWoltModalSheetPage(
        heroImage: const Image(
          image: NetworkImage(
            'https://res.cloudinary.com/daioibryi/image/upload/v1732673548/542884_vcfwca.jpg'
          ),
          fit:BoxFit.cover,
        ),
        mainContentSliversBuilder: (context) => [
          // Carrusel de imágenes
          if (imagePaths.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: SizedBox(
                  height: 250, // Ajusta la altura según tus necesidades
                  child: ImageCarousel(
                    imagePaths: imagePaths,
                  ),
                ),
              ),
            ),
          // Título del plan
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                plan['X_NOMBRE_PLAN'] ?? 'Sin título',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Descripción del plan
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                plan['X_DESCRIPCION'] ?? 'Sin descripción',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          // Botón de comprar
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
                  onPressed: isSubscribedToAnyPlan 
                    ? null
                    : () async {
                        final paymentApi = PaymentApi();
                        final amount = ((plan['N_PRECIO'] ?? 0) * 100).toInt();
                        const currency = 'PEN';
                        final planId = plan['N_ID_PLAN'] as int;
                        try {
                          await paymentApi.createPayment(amount, currency, planId, context, onPlanPurchased);
                          // ServicioNotificaciones.mostrarNotificacion(
                          //   '¡Gracias por tu compra!', 
                          //   'Gracias por comprar nuestro plan ${plan['X_NOMBRE_PLAN']}.', // Personalizar con el nombre del plan
                          // );
                          // onPlanPurchased();
                        } catch (e) {
                          if (context.mounted) {
                            FlashMessage.showError(
                              context,
                              'Pago no realizado',
                            );
                          }
                          }
                        },
                  child: Text(
                    isSubscribed
                        ? 'Suscrito a este plan'
                        : isSubscribedToAnyPlan
                            ? 'Ya estás suscrito a un plan'
                            : 'Comprar',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
