import 'package:flash/flash.dart';
import 'package:flutter/material.dart';

class FlashMessage {
  static void showSuccess(BuildContext context, String message) {
    _showFlash(context, "🌟 $message", Colors.green);
  }

  static void showError(BuildContext context, String message) {
    _showFlash(context, "⚠️ $message", Colors.red);
  }

  static void _showFlash(BuildContext context, String message, Color backgroundColor) {
    showFlash(
      context: context,
      duration: const Duration(seconds: 3),
      builder: (context, controller) {
        return Flash(
          controller: controller,
          position: FlashPosition.bottom,
          child: FlashBar(
            controller: controller,
            backgroundColor: backgroundColor,
            margin: const EdgeInsets.only(bottom: 30, left: 40, right: 40), 
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), 
            ),
            content: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
        );
      },
    );
  }
}
