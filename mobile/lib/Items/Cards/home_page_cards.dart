import 'package:flutter/material.dart';
import 'package:first_app/Items/Barrel/item_barrel.dart';
import 'package:first_app/Pages/Barrel/page_barrel.dart';
import 'package:first_app/models/workout_ui_model.dart';

class TodayWorkoutCard extends StatefulWidget {
  final WorkoutUiModel workout;
  final VoidCallback onCardClosed;

  const TodayWorkoutCard({
    super.key,
    required this.workout,
    required this.onCardClosed,
  });

  @override
  State<TodayWorkoutCard> createState() => _TodayWorkoutCardState();
}

class _TodayWorkoutCardState extends State<TodayWorkoutCard> {
  @override
  Widget build(BuildContext context) {
    final exerciseCount = widget.workout.workoutExercises.length;
    final setCount = widget.workout.workoutExercises.fold<int>(
      0,
      (sum, ex) => sum + ex.setList.length,
    );

    return Box(
      boxColor: color_2,
      softCorners: true,
      edgeSpaceAllBig: true,
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("TODAY'S WORKOUT", style: textStyleS),

            const SizedBox(height: 6),

            Text(widget.workout.name.toUpperCase(), style: textStyleL),

            const SizedBox(height: 6),

            Text(
              "$exerciseCount exercises • $setCount sets",
              style: textStyleS,
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: MyTextButton(
                text: "Start Workout",
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WorkoutViewPage(workout: widget.workout),
                    ),
                  );
                  widget.onCardClosed();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String text;
  const StatCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Box(
      boxColor: color_2,
      softCorners: true,
      edgeSpaceAllSmall: true,
      edgeSpaceHorizontal: true,
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextBox(
            text: text,
            textStyle: textStyleM,
            color: Colors.transparent,
            verticalPadding: 12,
            horizontalPadding: 0,
          ),
        ],
      ),
    );
  }
}
