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
          transitionBuilder: (Widget child, Animation<double> animation) {
            return PageTransition(
              type: PageTransitionType.fade,
              alignment: Alignment.center,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.5, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
              duration: const Duration(milliseconds: 300),
            ).child;
          },
          child: pages[currentPageIndex],
        ),
        // Loader de Lottie para la transición
        LottieLoader(isVisible: isLoading),
      ],
    );
  }
}
