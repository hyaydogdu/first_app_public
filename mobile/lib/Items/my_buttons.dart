import 'package:flutter/material.dart';
import 'package:first_app/Items/Barrel/item_barrel.dart';

class MyTextButton extends StatelessWidget {
  final String text;
  final Color? color;
  final Color? strokeColor;
  final Color? textColor;
  final double? elevation;
  final VoidCallback onPressed;

  const MyTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.strokeColor,
    this.textColor,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: color ?? accentColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        side: BorderSide(color: strokeColor ?? Colors.transparent),
        shadowColor: Colors.black,
        elevation: elevation ?? 0,
      ),
      onPressed: onPressed,
      child: Text(text, style: textStyleS, textAlign: TextAlign.center),
    );
  }
}

class BarIconButtons extends StatelessWidget {
  final Icon? buttonIcon;
  final VoidCallback onPressed;
  final double? size;
  const BarIconButtons({
    super.key,
    this.buttonIcon,
    required this.onPressed,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Box(
      boxColor: color_1,
      edgeSpaceAllSmall: true,
      softCorners: true,
      child: IconButton(
        icon: buttonIcon ?? Icon(Icons.arrow_back_ios_sharp),
        iconSize: size ?? 24,
        padding: EdgeInsets.zero,
        onPressed: onPressed,
      ),
    );
  }
}

class IconButtonS extends StatelessWidget {
  final VoidCallback onPressed;
  final double? size;
  const IconButtonS({super.key, required this.onPressed, this.size});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      iconSize: size ?? 24,
      alignment: Alignment.center,
      style: IconButton.styleFrom(shadowColor: Colors.black),
      icon: Icon(Icons.delete, color: Colors.black),
    );
  }
}
