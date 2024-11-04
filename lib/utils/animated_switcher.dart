import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:fitlunch/widgets/loading_animation.dart';

class CustomAnimatedSwitcher extends StatelessWidget {
  final int currentPageIndex;
  final List<Widget> pages;
  final bool isLoading;

  const CustomAnimatedSwitcher({
    super.key,
    required this.currentPageIndex,
    required this.pages,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300), 
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          child: isLoading
              ? Container(color: Colors.white) // Pantalla en blanco mientras carga
              : PageTransition(
                  type: PageTransitionType.fade,
                  alignment: Alignment.center,
                  child: pages[currentPageIndex],
                  duration: const Duration(milliseconds: 300),
                ).child,
        ),
        // Loader de Lottie para la transición
        if (isLoading)
          const LottieLoader(isVisible: true),
      ],
    );
  }
}
