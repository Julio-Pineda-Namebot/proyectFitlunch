import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieLoader extends StatelessWidget {
  final bool isVisible;

  const LottieLoader({super.key, required this.isVisible});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: Center(
        child: Lottie.asset(
          'assets/loading_animation.json', 
          width: 500,
          height: 500,
        ),
      ),
    );
  }
}
