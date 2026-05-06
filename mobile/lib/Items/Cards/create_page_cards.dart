import 'package:flutter/material.dart';
import 'package:first_app/Items/Barrel/item_barrel.dart';

class CreateCard extends StatelessWidget {
  final String text;
  final String? subtitle;
  final Icon? cardIcon;
  const CreateCard({
    super.key,
    required this.text,
    this.subtitle,
    this.cardIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Box(
      boxColor: color_1,
      softCorners: true,
      edgeSpaceAllBig: true,
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(text, style: textStyleM, textAlign: TextAlign.start),
            const SizedBox(height: 6),
            if (subtitle != null) ...[
              Text(subtitle!, style: textStyleS, textAlign: TextAlign.start),
              const SizedBox(height: 6),
            ],
            maxWidth(
              child: MyTextButton(text: "Create", onPressed: () {}),
            ),
          ],
        ),
      ),
    );
  }
}
