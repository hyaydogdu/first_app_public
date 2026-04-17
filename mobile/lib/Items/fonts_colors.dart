import 'package:flutter/material.dart';

final Color color_1 = Colors.white;
final Color color_2 = Colors.grey.shade200;
final Color accentColor = Colors.amber;

const double defaultHeight = 20.0;

const TextStyle textStyleS = TextStyle(
  fontFamily: "Urbanist",
  fontSize: 18,
  color: Colors.black, // buraya istediğin global renk
);

const TextStyle textStyleM = TextStyle(
  fontFamily: "Urbanist",
  fontSize: 24,
  color: Colors.black, // buraya istediğin global renk
);

const TextStyle textStyleL = TextStyle(
  fontFamily: "Urbanist",
  fontSize: 36,
  color: Colors.black, // buraya istediğin global renk
);

String formatWeight(double kg) {
  return kg % 1 == 0 ? kg.toInt().toString() : kg.toString();
}
