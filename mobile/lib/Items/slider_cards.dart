import 'package:first_app/Items/Barrel/item_barrel.dart';
import 'package:first_app/Pages/Barrel/page_barrel.dart';
import 'package:first_app/models/weekly_plan_ui_model.dart';
import 'package:first_app/models/workout_ui_model.dart';
import 'package:flutter/material.dart';

class WorkoutCard extends StatelessWidget {
  final WorkoutUiModel workout;
  final VoidCallback onCardClosed;

  const WorkoutCard({
    super.key,
    required this.workout,
    required this.onCardClosed,
  });

  @override
  Widget build(BuildContext context) {
    final exerciseCount = workout.workoutExercises.length;
    final setCount = workout.workoutExercises.fold<int>(
      0,
      (sum, ex) => sum + ex.setList.length,
    );

    return Box(
      softCorners: true,
      boxColor: color_1, // slider içindeyken kart beyaz olmalı
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              workout.name.toUpperCase(),
              style: textStyleM,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text(
              "$exerciseCount exercises • $setCount sets",
              style: textStyleS, // yoksa textStyleM ama opacity düşür
            ),
            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: MyTextButton(
                text: "Start Workout",
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WorkoutViewPage(workout: workout),
                    ),
                  );
                  onCardClosed();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlanCard extends StatelessWidget {
  final WeeklyPlanUiModel weeklyPlan;
  final VoidCallback onCardClosed;
  const PlanCard({
    super.key,
    required this.weeklyPlan,
    required this.onCardClosed,
  });

  @override
  Widget build(BuildContext context) {
    final workoutDays = [
      weeklyPlan.week?.mondayWorkout,
      weeklyPlan.week?.tuesdayWorkout,
      weeklyPlan.week?.wednesdayWorkout,
      weeklyPlan.week?.thursdayWorkout,
      weeklyPlan.week?.fridayWorkout,
      weeklyPlan.week?.saturdayWorkout,
      weeklyPlan.week?.sundayWorkout,
    ].where((workout) => workout != null).length;

    return Box(
      softCorners: true,
      boxColor: color_1,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              weeklyPlan.name.toUpperCase(),
              style: textStyleM,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text("$workoutDays workout days", style: textStyleS),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: MyTextButton(
                text: "View Plan",
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          WeeklyPlanViewPage(weeklyPlan: weeklyPlan),
                    ),
                  );
                  onCardClosed();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
