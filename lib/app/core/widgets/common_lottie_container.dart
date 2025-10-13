import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CommonLottieContainer extends StatelessWidget {
  final String assetName; // Lottie file path (assets or network)
  final double size;
  final BoxFit fit;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final double borderRadius;
  final bool repeat;
  final bool animate;
  final bool fromNetwork;

  const CommonLottieContainer({
    super.key,
    required this.assetName,
    this.size = 100,
    this.fit = BoxFit.contain,
    this.padding = const EdgeInsets.all(8.0),
    this.backgroundColor,
    this.borderRadius = 8.0,
    this.repeat = true,
    this.animate = true,
    this.fromNetwork = false, // For network Lottie files
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: fromNetwork
          ? Lottie.network(
              assetName,
              width: size,
              height: size,
              fit: fit,
              repeat: repeat,
              animate: animate,
            )
          : Lottie.asset(
              assetName,
              width: size,
              height: size,
              fit: fit,
              repeat: repeat,
              animate: animate,
            ),
    );
  }
}
