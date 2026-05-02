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
    WorkoutUiModel? theWorkout = _findDayWorkout(weeklyPlan, day);
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
        strokeColor: theWorkout != null ? null : cardColor,
        softCorners: true,
        edgeSpaceAllSmall: true,
        edgeSpaceHorizontal: true,
        elevation: theWorkout != null ? 4 : 0,
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _onePiece(
                    alignment: Alignment.centerLeft,
                    boxRight: 1,
                    height: defaultHeight,
                    child: Text(
                      textCase("", TextCaseMode.title),
                      style: textStyleL,
                    ),
                  ),
                  _onePiece(
                    alignment: Alignment.topLeft,
                    boxRight: 1,
                    height: defaultHeight * 2,
                    child: Text(
                      textCase(day, TextCaseMode.title),
                      style: textStyleM,
                    ),
                  ),

                  _onePiece(
                    alignment: Alignment.topLeft,
                    boxRight: 1,
                    height: defaultHeight * 2,
                    child: Text(
                      textCase(
                        theWorkout?.name ?? "Rest Day",
                        TextCaseMode.title,
                      ),
                      style: textStyleM,
                    ),
                  ),
                  _onePiece(
                    alignment: Alignment.topLeft,
                    boxRight: 1,
                    height: defaultHeight * 3,
                    child: Text(
                      textCase(
                        theWorkout?.description ?? "Enjoy your rest day!",
                        TextCaseMode.sentence,
                      ),
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
                  _onePiece(
                    alignment: Alignment.center,
                    boxLeft: 0,
                    height: defaultHeight * 3.5,
                    child: Box(
                      boxColor: color_1,
                      softCorners: true,
                      child: SizedBox(
                        height: defaultHeight * 1.5,
                        width: defaultHeight * 5,
                        child: Text(
                          theWorkout != null
                              ? "${_findTotalSets(theWorkout)} sets"
                              : "Rest",
                          style: textStyleS,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  _onePiece(
                    alignment: Alignment.center,
                    boxLeft: 0,
                    height: defaultHeight * 3.5,
                    child: Box(
                      boxColor: color_1,
                      softCorners: true,
                      child: SizedBox(
                        height: defaultHeight * 1.5,
                        width: defaultHeight * 5,
                        child: Text(
                          theWorkout != null
                              ? "${theWorkout.workoutExercises.length} exercises"
                              : "Rest",
                          style: textStyleS,
                          textAlign: TextAlign.center,
                        ),
                      ),
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

class WeekDayCardEdit extends StatefulWidget {
  final String day;
  final WeeklyPlanUiModel weeklyPlan;
  const WeekDayCardEdit({
    super.key,
    required this.day,
    required this.weeklyPlan,
  });

  @override
  State<WeekDayCardEdit> createState() => _WeekDayCardEditState();
}

class _WeekDayCardEditState extends State<WeekDayCardEdit> {
  @override
  Widget build(BuildContext context) {
    WorkoutUiModel? theWorkout = _findDayWorkout(widget.weeklyPlan, widget.day);
    final Color cardColor = color_2;
    return InkWell(
      onTap: theWorkout == null
          ? null
          : () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SelectWorkoutPage()),
              );
            },
      child: BorderBox(
        boxColor: cardColor,
        strokeColor: theWorkout != null ? null : cardColor,
        softCorners: true,
        edgeSpaceAllSmall: true,
        edgeSpaceHorizontal: true,
        elevation: theWorkout != null ? 4 : 0,
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _onePiece(
                    alignment: Alignment.centerLeft,
                    boxRight: 1,
                    height: defaultHeight,
                    child: Text(
                      textCase("", TextCaseMode.title),
                      style: textStyleL,
                    ),
                  ),
                  _onePiece(
                    alignment: Alignment.topLeft,
                    boxRight: 1,
                    height: defaultHeight * 2,
                    child: Text(
                      textCase(widget.day, TextCaseMode.title),
                      style: textStyleM,
                    ),
                  ),

                  _onePiece(
                    alignment: Alignment.topLeft,
                    boxRight: 1,
                    height: defaultHeight * 2,
                    child: Text(
                      textCase(
                        theWorkout?.name ?? "Rest Day",
                        TextCaseMode.title,
                      ),
                      style: textStyleM,
                    ),
                  ),
                  _onePiece(
                    alignment: Alignment.topLeft,
                    boxRight: 1,
                    height: defaultHeight * 3,
                    child: Text(
                      textCase(
                        theWorkout?.description ?? "Enjoy your rest day!",
                        TextCaseMode.sentence,
                      ),
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
                  _onePiece(
                    alignment: Alignment.centerRight,
                    boxLeft: 1,
                    height: defaultHeight * 7,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: accentColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          // side: BorderSide(color: Colors.black),
                        ),
                      ),
                      onPressed: () async {},
                      child: Text("View Workout", style: textStyleS),
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

Widget _onePiece({
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
            boxColor: Colors.transparent,
            child: Align(alignment: alignment, child: child),
          ),
        ),
        if (boxLeft != null)
          for (int i = 0; i < boxLeft; i++) SizedBox(width: defaultHeight),
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
