import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommonSvgContainer extends StatelessWidget {
  final String assetName;
  final double size;
  final Color? color;
  final BoxFit fit;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final double borderRadius;

  const CommonSvgContainer({
    super.key,
    required this.assetName,
    this.size = 24,
    this.color,
    this.fit = BoxFit.contain,
    this.padding = const EdgeInsets.all(8.0),
    this.backgroundColor,
    this.borderRadius = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: SvgPicture.asset(
        assetName,
        width: size,
        height: size,
        colorFilter: color != null
            ? ColorFilter.mode(color!, BlendMode.srcIn)
            : null,
        fit: fit,
      ),
    );
  }
}
