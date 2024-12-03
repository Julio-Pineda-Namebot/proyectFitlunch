import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fitlunch/utils/storage_utils.dart';
import 'package:fitlunch/widgets/components/flash_message.dart';
import 'package:logger/logger.dart';

class PaymentApi {
  final String _baseUrl = 'https://backend-fitlunch.onrender.com';

  final logger = Logger();

  Future<void> createPayment(int amount, String currency, int planId, BuildContext context, VoidCallback onPlanPurchased) async {
    final response = await createPaymentIntent(amount, currency, planId);
    final clientSecret = response['clientSecret'];

    if (clientSecret == null) {
      throw Exception('Failed to retrieve client secret');
    }

    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        style: ThemeMode.system,
        merchantDisplayName: 'FitLunch',
      ),
    ).then((_) {
      // Mostrar PaymentSheet y manejar el resultado
      Stripe.instance.presentPaymentSheet().then((_) {
        // Obtener el PaymentIntent ID para la confirmación
        final paymentIntentId = response['paymentIntentId'] as String?; // Asegúrate de que response contiene paymentIntentId

        if (paymentIntentId != null) {
          // Confirmar el pago en el backend
          if (context.mounted){
            confirmPayment(paymentIntentId, planId, context, onPlanPurchased);
          }
        } else {
          // Manejar el caso en que paymentIntentId sea nulo
          logger.e('Error: paymentIntentId is null');
        }
      }).onError((error, stackTrace) {
        // Manejar errores al mostrar PaymentSheet
        if (context.mounted){
          cancelPendingPayment(planId, context);
        }
        logger.e('Error al mostrar PaymentSheet: $error');
      });
    });

    // await Stripe.instance.presentPaymentSheet();
    // // Confirmar el pago en el backend
    // await confirmPayment(response['paymentIntentId'], planId);
  }

  Future<Map<String, dynamic>> createPaymentIntent(int amount, String currency, int planId) async {
    final authToken = await StorageUtils.getAuthToken();
    if (authToken == null) {
      throw Exception('Token de autenticación no encontrado');
    }
    final url = Uri.parse('$_baseUrl/payment/create-payment-intent');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: jsonEncode({'amount': amount, 'currency': currency, 'planId': planId}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create PaymentIntent');
    }
  }

  Future<void> confirmPayment(String paymentIntentId, int planId, BuildContext context, VoidCallback onPlanPurchased) async {
    final authToken = await StorageUtils.getAuthToken();
    if (authToken == null) {
      throw Exception('Token de autenticación no encontrado');
    }
    final url = Uri.parse('$_baseUrl/payment/confirm-payment');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken', 
      },
      body: jsonEncode({'paymentIntentId': paymentIntentId, 'planId': planId}),
    );

    if (response.statusCode == 200) {
      // Mostrar mensaje de éxito y cerrar el modal
      if (context.mounted) {
        FlashMessage.showSuccess(
          context,
          'Pago realizado con éxito',
        );
        onPlanPurchased();
        Navigator.of(context).pop(); // Cerrar el modal
      }
    } else {
      throw Exception('Error al confirmar el pago: ${response.body}');
    }
  }

  Future<void> cancelPendingPayment(int planId, BuildContext context) async {
    final authToken = await StorageUtils.getAuthToken();
    if (authToken == null) {
      throw Exception('Token de autenticación no encontrado');
    }
    final url = Uri.parse('$_baseUrl/payment/cancel-pending-payment'); 
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: jsonEncode({'planId': planId}), // Envía el planId para identificar el pago
    );

    if (response.statusCode == 200) {
      // Manejar la respuesta exitosa del backend (opcional)
      logger.i('Pago pendiente cancelado con éxito');
    } else {
      // Manejar el error (opcional)
      logger.e('Error al cancelar el pago pendiente: ${response.body}');
    }
  }
}

