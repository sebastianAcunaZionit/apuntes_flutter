import 'package:flutter/material.dart';

enum BorderVariant {
  all,
  top,
  bottom,
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
  none
}

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    super.key,
    this.color,
    this.width = double.infinity,
    this.height,
    this.child,
    this.borderRadius = 15,
    this.borderVariant = BorderVariant.none,
    this.border,
    this.margin,
  });

  final Color? color;
  final double width;
  final Widget? child;
  final double borderRadius;
  final BorderVariant borderVariant;
  final double? height;
  final BoxBorder? border;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final BorderRadius? radiusBorder;

    switch (borderVariant) {
      case BorderVariant.all:
        radiusBorder = BorderRadius.circular(borderRadius);
        break;
      case BorderVariant.none:
        radiusBorder = null;
        break;
      case BorderVariant.top:
        radiusBorder = BorderRadius.only(
            topLeft: Radius.circular(borderRadius),
            topRight: Radius.circular(borderRadius));
        break;
      case BorderVariant.bottom:
        radiusBorder = BorderRadius.only(
            bottomLeft: Radius.circular(borderRadius),
            bottomRight: Radius.circular(borderRadius));
        break;
      case BorderVariant.topLeft:
        radiusBorder =
            BorderRadius.only(topLeft: Radius.circular(borderRadius));
        break;
      case BorderVariant.topRight:
        radiusBorder =
            BorderRadius.only(topRight: Radius.circular(borderRadius));
        break;
      case BorderVariant.bottomLeft:
        radiusBorder =
            BorderRadius.only(bottomLeft: Radius.circular(borderRadius));
        break;
      case BorderVariant.bottomRight:
        radiusBorder =
            BorderRadius.only(bottomRight: Radius.circular(borderRadius));
        break;
      default:
        radiusBorder = null;
        break;
    }

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
          color: color, borderRadius: radiusBorder, border: border),
      child: child,
    );
  }
}
