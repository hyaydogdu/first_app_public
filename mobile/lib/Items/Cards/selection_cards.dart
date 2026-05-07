// 🔥 Exercise Selection sayfası için kullanılan kart
import 'package:first_app/models/exercise_ui_model.dart';
import 'package:first_app/models/workout_ui_model.dart';
import 'package:flutter/material.dart';
import 'package:first_app/Items/Barrel/item_barrel.dart';

class SelectExerciseCard extends StatelessWidget {
  final ExerciseUiModel exercise;
  final VoidCallback onViewExercise;

  const SelectExerciseCard({
    super.key,
    required this.exercise,
    required this.onViewExercise,
  });

  @override
  Widget build(BuildContext context) {
    final Color cardColor = color_2;

    return InkWell(
      onTap: () => Navigator.pop(context, exercise),
      child: BorderBox(
        boxColor: cardColor,
        strokeColor: cardColor,
        softCorners: true,
        edgeSpaceAllSmall: true,
        edgeSpaceHorizontal: true,
        elevation: 4,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  cardPart(height: defaultHeight),
                  cardPart(
                    alignment: Alignment.centerLeft,
                    boxLeft: 1,
                    height: defaultHeight * 4,
                    child: imageDisplayer(
                      exercise.imageUrl!,
                      size: defaultHeight * 4,
                    ),
                  ),

                  cardPart(height: defaultHeight),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  cardPart(
                    alignment: Alignment.centerLeft,
                    boxLeft: 0,
                    height: defaultHeight * 6,
                    child: Text(exercise.name, style: textStyleM),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  cardPart(
                    alignment: Alignment.centerRight,
                    boxRight: 1,
                    height: defaultHeight * 6,
                    child: MyTextButton(
                      text: "View \nExercise",
                      textStyle: textStyleS,
                      strokeColor: Colors.black,
                      onPressed: onViewExercise,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SelectWorkoutCard extends StatelessWidget {
  final WorkoutUiModel workout;
  final VoidCallback onViewWorkout;

  const SelectWorkoutCard({
    super.key,
    required this.workout,
    required this.onViewWorkout,
  });

  @override
  Widget build(BuildContext context) {
    final Color cardColor = color_2;

    return InkWell(
      onTap: onViewWorkout,
      child: BorderBox(
        boxColor: cardColor,
        strokeColor: cardColor,
        softCorners: true,
        edgeSpaceAllSmall: true,
        edgeSpaceHorizontal: true,
        elevation: 4,
        child: Row(
          children: [
            Expanded(child: cardPart(height: defaultHeight)),
            Expanded(
              child: cardPart(
                height: defaultHeight * 4,
                child: Text(workout.name, style: textStyleM),
              ),
            ),
            Expanded(
              child: cardPart(
                height: defaultHeight * 4,
                alignment: Alignment.centerRight,
                boxRight: 1,
                child: MyTextButton(
                  text: "View \nWorkout",
                  textStyle: textStyleS,
                  strokeColor: Colors.black,
                  onPressed: onViewWorkout,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
