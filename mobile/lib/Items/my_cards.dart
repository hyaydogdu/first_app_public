import 'package:first_app/models/weekly_plan_ui_model.dart';
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
      boxColor: color_1,
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
              style: textStyleM,
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
      elevation: 4,
      boxColor: Colors.white, // slider içindeyken kart beyaz olmalı
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
            _makeBigger(
              child: MyTextButton(text: "Create", onPressed: () {}),
            ),
          ],
        ),
      ),
    );
  }

  Widget _makeBigger({required Widget child}) {
    return SizedBox(width: double.infinity, child: child);
  }
}

class StatCard extends StatelessWidget {
  final String text;
  const StatCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Box(
      boxColor: color_1,
      softCorners: true,
      edgeSpaceAllSmall: true,
      edgeSpaceHorizontal: true,
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: defaultHeight / 2),
          TextBox(text: text, textStyle: textStyleM, color: Colors.transparent),
          SizedBox(height: defaultHeight / 2),
        ],
      ),
    );
  }
}

class WeeklyPlanCard extends StatelessWidget {
  final WeeklyPlanUiModel weeklyPlan;
  final VoidCallback onCardClosed;
  const WeeklyPlanCard({
    super.key,
    required this.weeklyPlan,
    required this.onCardClosed,
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
            Text("Weekly Plan", style: textStyleM, textAlign: TextAlign.start),
            const SizedBox(height: 6),
            maxWidth(
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

class WeekDayCard extends StatelessWidget {
  final String day;
  final WeeklyPlanUiModel weeklyPlan;
  const WeekDayCard({super.key, required this.day, required this.weeklyPlan});

  @override
  Widget build(BuildContext context) {
    return Box(
      boxColor: color_2,
      softCorners: true,
      edgeSpaceAllSmall: true,
      edgeSpaceHorizontal: true,
      elevation: 4,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                onePiece(
                  alignment: Alignment.centerLeft,
                  boxRight: 1,
                  height: defaultHeight * 3,
                  child: Text(day, style: textStyleM),
                ),

                onePiece(
                  alignment: Alignment.topLeft,
                  boxRight: 1,
                  height: defaultHeight * 2,
                  child: Text(
                    findDay(day)?.name ?? "Rest Day",
                    style: textStyleS,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                onePiece(
                  alignment: Alignment.centerRight,
                  boxLeft: 1,
                  height: defaultHeight * 5,
                  child: Icon(Icons.work_history_outlined, size: 48),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget onePiece({
    required Alignment alignment,
    int? boxRight,
    int? boxLeft,
    required Widget child,
    required double height,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(height: height),
      child: Row(
        children: [
          if (boxRight != null)
            for (int i = 0; i < boxRight; i++) SizedBox(width: defaultHeight),
          Expanded(
            child: Box(
              boxColor: color_2,
              child: Align(alignment: alignment, child: child),
            ),
          ),
          if (boxLeft != null)
            for (int i = 0; i < boxLeft; i++) SizedBox(width: defaultHeight),
        ],
      ),
    );
  }

  WorkoutUiModel? findDay(String day) {
    switch (day) {
      case "Monday":
        return weeklyPlan.week!.mondayWorkout;
      case "Tuesday":
        return weeklyPlan.week!.tuesdayWorkout;
      case "Wednesday":
        return weeklyPlan.week!.wednesdayWorkout;
      case "Thursday":
        return weeklyPlan.week!.thursdayWorkout;
      case "Friday":
        return weeklyPlan.week!.fridayWorkout;
      case "Saturday":
        return weeklyPlan.week!.saturdayWorkout;
      case "Sunday":
        return weeklyPlan.week!.sundayWorkout;
      default:
        return null;
    }
  }
}
