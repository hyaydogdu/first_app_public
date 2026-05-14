import 'package:first_app/items/fonts_colors.dart';
import 'package:flutter/material.dart';

class BorderBox extends StatelessWidget {
  final Color? boxColor;
  final Color? strokeColor;
  final Color? shadowColor;
  final Widget child;
  final bool? edgeSpaceAllBig;
  final bool? edgeSpaceAllSmall;
  final bool? edgeSpaceHorizontal;
  final bool? softCorners;

  final double? elevation; // 👈 gerçek elevation
  final VoidCallback? onTap; // opsiyonel: tıklanabilir kart

  const BorderBox({
    super.key,
    this.boxColor,
    this.strokeColor,
    this.shadowColor,
    required this.child,
    this.edgeSpaceAllBig,
    this.edgeSpaceHorizontal,
    this.softCorners,
    this.edgeSpaceAllSmall,
    this.onTap,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    final radius = (softCorners == true)
        ? BorderRadius.circular(14)
        : BorderRadius.zero;

    return Container(
      alignment: AlignmentDirectional.center,
      padding: EdgeInsets.symmetric(
        horizontal: edgeSpaceHorizontal == true ? 10 : 0,
      ),
      margin: EdgeInsets.all(
        edgeSpaceAllBig == true
            ? 20
            : edgeSpaceAllSmall == true
            ? 10
            : 0,
      ), // kutular arası boşluk

      child: Material(
        color: boxColor ?? color_1,
        shadowColor: shadowColor ?? Colors.black,
        elevation: elevation ?? 0,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(color: strokeColor ?? Colors.black, width: 1),
        ),
        clipBehavior: Clip
            .antiAlias, // köşelerden taşmayı engeller (video/resim için şart)

        child: InkWell(
          onTap: onTap, // null olursa ripple olmaz
          borderRadius: radius,
          child: child,
        ),
      ),
    );
  }
}

class Box extends StatelessWidget {
  final Widget child;
  final Color? boxColor;
  final bool? edgeSpaceAllBig;
  final bool? edgeSpaceAllSmall;
  final bool? edgeSpaceHorizontal;
  final bool? softCorners;

  final double? elevation; // 👈 gerçek elevation
  final VoidCallback? onTap; // opsiyonel: tıklanabilir kart

  const Box({
    super.key,
    required this.child,
    this.boxColor,
    this.edgeSpaceAllBig,
    this.edgeSpaceHorizontal,
    this.softCorners,
    this.edgeSpaceAllSmall,
    this.elevation,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = (softCorners == true)
        ? BorderRadius.circular(14)
        : BorderRadius.zero;

    return Container(
      alignment: AlignmentDirectional.center,
      padding: EdgeInsets.symmetric(
        horizontal: edgeSpaceHorizontal == true ? 10 : 0,
      ),
      margin: EdgeInsets.all(
        edgeSpaceAllBig == true
            ? 20
            : edgeSpaceAllSmall == true
            ? 10
            : 0,
      ),

      // 👇 gerçek elevation burada
      child: Material(
        color: boxColor,
        elevation: elevation ?? 0,
        borderRadius: radius,
        clipBehavior: Clip
            .antiAlias, // köşelerden taşmayı engeller (video/resim için şart)

        child: InkWell(
          onTap: onTap, // null olursa ripple olmaz
          borderRadius: radius,
          child: child,
        ),
      ),
    );
  }
}
