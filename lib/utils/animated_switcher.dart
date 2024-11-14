import 'package:flutter/material.dart';
import 'package:fitlunch/widgets/components/loading_animation.dart';

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
          child: pages[currentPageIndex],
        ),
        LottieLoader(isVisible: isLoading),
      ],
    );
  }
}
