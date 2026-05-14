import 'package:first_app/Items/Barrel/item_barrel.dart';
import 'package:first_app/Pages/Barrel/page_barrel.dart';
import 'package:first_app/models/weekly_plan_ui_model.dart';
import 'package:first_app/models/workout_ui_model.dart';
import 'package:flutter/material.dart';

class WeekDayCard extends StatelessWidget {
  final String day;
  final WeeklyPlanUiModel weeklyPlan;
  final Future<void> Function(String day, WorkoutUiModel workout)?
  onWorkoutClosed;

  const WeekDayCard({
    super.key,
    required this.day,
    required this.weeklyPlan,
    this.onWorkoutClosed,
  });

  @override
  Widget build(BuildContext context) {
    return _WeekDayCardBase(
      day: day,
      weeklyPlan: weeklyPlan,
      onWorkoutClosed: onWorkoutClosed,
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
  final Future<void> Function(String day, WorkoutUiModel? workout)
  onWorkoutChanged;
  final Future<void> Function(String day, WorkoutUiModel workout)?
  onWorkoutClosed;

  const WeekDayCardEdit({
    super.key,
    required this.day,
    required this.weeklyPlan,
    required this.onWorkoutChanged,
    this.onWorkoutClosed,
  });

  @override
  Widget build(BuildContext context) {
    return _WeekDayCardBase(
      day: day,
      weeklyPlan: weeklyPlan,
      onWorkoutClosed: onWorkoutClosed,
      boxRightCount: 1,
      rightSideBuilder: (theWorkout) => [
        MyTextButton(
          color: accentColor,
          strokeColor: Colors.black,
          text: theWorkout == null ? "Add     Workout" : "Change Workout",
          onPressed: () async {
            final selected = await Navigator.push<Object?>(
              context,
              MaterialPageRoute(builder: (_) => SelectWorkoutPage()),
            );

            if (selected == null) return;

            if (selected == SelectWorkoutResult.restDay) {
              await onWorkoutChanged(day, null);
              return;
            }

            if (selected is WorkoutUiModel) {
              await onWorkoutChanged(day, selected);
            }
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
  final Future<void> Function(String day, WorkoutUiModel workout)?
  onWorkoutClosed;
  final List<Widget> Function(WorkoutUiModel? workout) rightSideBuilder;

  const _WeekDayCardBase({
    required this.day,
    required this.weeklyPlan,
    this.onWorkoutClosed,
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
              await onWorkoutClosed?.call(day, theWorkout);
            },
      child: BorderBox(
        boxColor: cardColor,
        strokeColor: cardColor,
        softCorners: true,
        edgeSpaceAllSmall: true,
        edgeSpaceHorizontal: true,
        elevation: theWorkout == null ? 0 : 4,
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  cardPart(height: defaultHeight),
                  cardPart(
                    alignment: Alignment.topLeft,
                    boxLeft: 1,
                    height: defaultHeight * 2,
                    child: Text(day, style: textStyleM),
                  ),
                  cardPart(
                    alignment: Alignment.topLeft,
                    boxLeft: 1,
                    height: defaultHeight * 2,
                    child: Text(
                      theWorkout?.name ?? "Rest Day",
                      style: textStyleM,
                    ),
                  ),
                  cardPart(
                    alignment: Alignment.topLeft,
                    boxLeft: 1,
                    height: defaultHeight * 3,
                    child: Text(
                      theWorkout == null
                          ? "Rest Day"
                          : theWorkout.description?.trim() ?? "Workout",
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
                    cardPart(
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

WorkoutUiModel? _findDayWorkout(WeeklyPlanUiModel weeklyPlan, String day) {
  if (weeklyPlan.week == null) {
    return null;
  }

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
