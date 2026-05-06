import 'package:first_app/Items/fonts_colors.dart';
import 'package:first_app/Items/my_boxs.dart';
import 'package:first_app/Services/api_config.dart';
import 'package:flutter/material.dart';

Widget imageDisplayer(String imageUrl, {double size = 56}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: Image.network(
      ApiConfig.endpoint(imageUrl),
      height: size,
      width: size,
      fit: BoxFit.cover,
    ),
  );
}

Widget maxWidth({required Widget child}) {
  return SizedBox(width: double.infinity, child: child);
}

Widget cardPart({
  // tool to create parts of cards with consistent spacing and alignment
  Alignment? alignment,
  int? boxRight,
  int? boxLeft,
  Widget? child,
  required double height,
}) {
  return ConstrainedBox(
    constraints: BoxConstraints.tightFor(height: height),
    child: Row(
      children: [
        if (boxLeft != null)
          for (int i = 0; i < boxLeft; i++) SizedBox(width: defaultHeight),
        child != null
            ? Expanded(
                child: Box(
                  boxColor: Colors.transparent,
                  child: Align(
                    alignment: alignment ?? Alignment.center,
                    child: child,
                  ),
                ),
              )
            : SizedBox(),
        if (boxRight != null)
          for (int i = 0; i < boxRight; i++) SizedBox(width: defaultHeight),
      ],
    ),
  );
}
