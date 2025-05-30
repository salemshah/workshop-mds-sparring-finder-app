import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AppLottieLoader extends StatelessWidget {
  final double size;
  final String animationPath;
  final Color? backgroundColor;
  final AnimationController? controller;
  final bool repeat;
  final void Function(LottieComposition)? onLoaded;

  const AppLottieLoader({
    super.key,
    required this.size,
    required this.animationPath,
    this.backgroundColor,
    this.controller,
    this.onLoaded,
    this.repeat = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? Colors.transparent,
      alignment: Alignment.center,
      child: Lottie.asset(
        animationPath,
        controller: controller,
        onLoaded: onLoaded,
        repeat: repeat,
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    );
  }
}
