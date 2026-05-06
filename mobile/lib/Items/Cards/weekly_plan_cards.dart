import 'package:first_app/Items/Barrel/item_barrel.dart';
import 'package:first_app/Pages/Barrel/page_barrel.dart';
import 'package:first_app/models/weekly_plan_ui_model.dart';
import 'package:first_app/models/workout_ui_model.dart';
import 'package:flutter/material.dart';

class WeekDayCard extends StatelessWidget {
  final String day;
  final WeeklyPlanUiModel weeklyPlan;

  const WeekDayCard({super.key, required this.day, required this.weeklyPlan});

  @override
  Widget build(BuildContext context) {
    return _WeekDayCardBase(
      day: day,
      weeklyPlan: weeklyPlan,
      boxRightCount: 0,
      rightSideBuilder: (workout) => [
        TextBox(
          text: workout != null ? "${_findTotalSets(workout)} sets" : "Rest",
          textStyle: textStyleS,
          color: accentColor,
        ),
        TextBox(
          text: workout != null
              ? "${workout.workoutExercises.length} exercises"
              : "Rest",
          textStyle: textStyleS,
          color: accentColor,
        ),
      ],
    );
  }
}

class WeekDayCardEdit extends StatelessWidget {
  final String day;
  final WeeklyPlanUiModel weeklyPlan;

  const WeekDayCardEdit({
    super.key,
    required this.day,
    required this.weeklyPlan,
  });

  @override
  Widget build(BuildContext context) {
    return _WeekDayCardBase(
      day: day,
      weeklyPlan: weeklyPlan,
      boxRightCount: 1,
      rightSideBuilder: (theWorkout) => [
        MyTextButton(
          color: accentColor,
          strokeColor: Colors.black,
          text: theWorkout == null ? "Add     Workout" : "Change Workout",
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SelectWorkoutPage()),
            );
          },
        ),
      ],
    );
  }
}

class _WeekDayCardBase extends StatelessWidget {
  final String day;
  final WeeklyPlanUiModel weeklyPlan;
  final int boxRightCount;
  final List<Widget> Function(WorkoutUiModel? workout) rightSideBuilder;

  const _WeekDayCardBase({
    required this.day,
    required this.weeklyPlan,
    this.boxRightCount = 0,
    required this.rightSideBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final theWorkout = _findDayWorkout(weeklyPlan, day);
    final rightWidgets = rightSideBuilder(theWorkout);

    final Color cardColor = color_2;

    return InkWell(
      onTap: theWorkout == null
          ? null
          : () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WorkoutViewPage(workout: theWorkout),
                ),
              );
            },
      child: BorderBox(
        boxColor: cardColor,
        strokeColor: cardColor,
        softCorners: true,
        edgeSpaceAllSmall: true,
        edgeSpaceHorizontal: true,
        elevation: theWorkout != null ? 8 : 0,
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _cardPart(height: defaultHeight),
                  _cardPart(
                    alignment: Alignment.topLeft,
                    boxLeft: 1,
                    height: defaultHeight * 2,
                    child: Text(day, style: textStyleM),
                  ),
                  _cardPart(
                    alignment: Alignment.topLeft,
                    boxLeft: 1,
                    height: defaultHeight * 2,
                    child: Text(
                      theWorkout?.name ?? "Rest Day",
                      style: textStyleM,
                    ),
                  ),
                  _cardPart(
                    alignment: Alignment.topLeft,
                    boxLeft: 1,
                    height: defaultHeight * 3,
                    child: Text(
                      theWorkout?.description ?? "Enjoy your rest day!",
                      style: textStyleSGrey,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var widget in rightWidgets)
                    _cardPart(
                      boxRight: boxRightCount,
                      height: defaultHeight * 7 / rightWidgets.length,
                      child: widget,
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

Widget _cardPart({
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

WorkoutUiModel? _findDayWorkout(WeeklyPlanUiModel weeklyPlan, String day) {
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

int _findTotalSets(WorkoutUiModel workout) {
  return workout.workoutExercises.fold<int>(
    0,
    (sum, ex) => sum + ex.setList.length,
  );
}
