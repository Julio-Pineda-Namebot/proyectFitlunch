import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:fitlunch/widgets/components/image_carousel.dart';

void showPlanModal(BuildContext context, Map<String, dynamic> plan) {
  final List<String> imagePaths = (plan['fit_images'] as List<dynamic>?)
          ?.map((image) => image['X_URL'] as String)
          .toList() ??
      [];
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
                  onPressed: () {
                    // Acción de compra
                    Navigator.of(bottomSheetContext).pop();
                  },
                  child: const Text('Comprar'),
                ),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}
