// 🔥 Exercise Selection sayfası için kullanılan kart
import 'package:first_app/models/exercise_ui_model.dart';
import 'package:flutter/material.dart';
import 'package:first_app/Items/Barrel/item_barrel.dart';

class SelectExerciseCard extends StatelessWidget {
  final ExerciseUiModel exercise;
  const SelectExerciseCard({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context, exercise);
      },
      borderRadius: BorderRadius.circular(8),
      child: BorderBox(
        boxColor: color_1,
        edgeSpaceAllSmall: true,
        softCorners: true,
        child: Row(children: [Text(exercise.name, style: textStyleM)]),
      ),
    );
  }
}
