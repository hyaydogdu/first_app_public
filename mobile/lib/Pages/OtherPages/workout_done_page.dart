import 'package:first_app/Items/Barrel/item_barrel.dart';
import 'package:first_app/main.dart';
import 'package:first_app/models/workout_ui_model.dart';
import 'package:flutter/material.dart';

class WorkoutDonePage extends DefaultPage {
  final WorkoutUiModel workout;
  final int workoutTime;
  const WorkoutDonePage({
    super.key,
    required this.workout,
    required this.workoutTime,
  });
  @override
  String get pageName => workout.name;
  @override
  State<WorkoutDonePage> createState() => _WorkoutDonePage();
}

class _WorkoutDonePage extends State<WorkoutDonePage> {
  @override
  Widget build(BuildContext context) {
    int totalSets = 0;
    for (var exercise in widget.workout.workoutExercises) {
      totalSets += exercise.setList.length;
    }
    return Scaffold(
      backgroundColor: color_1,
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.pageName),
        backgroundColor: Colors.transparent,
        leading: BarIconButtons(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => MainPage()),
              (route) => false,
            );
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: defaultHeight),
            Icon(Icons.check_circle_outline, size: 100, color: accentColor),
            Text("Nice Work!", style: textStyleL, textAlign: TextAlign.center),
            SizedBox(height: defaultHeight / 2),
            Text(
              "You've completed the workout",
              style: textStyleM,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: defaultHeight),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: defaultHeight,
              children: [
                Expanded(flex: 1, child: SizedBox()),
                Expanded(
                  flex: 4,
                  child: StatBox(
                    text: "Minutes",
                    stat:
                        "${(widget.workoutTime ~/ 60).toString().padLeft(2, '0')}:${(widget.workoutTime % 60).toString().padLeft(2, '0')}",
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: StatBox(text: "Sets", stat: totalSets.toString()),
                ),
                Expanded(
                  flex: 4,
                  child: StatBox(
                    text: "Exercises",
                    stat: widget.workout.workoutExercises.length.toString(),
                  ),
                ),
                Expanded(flex: 1, child: SizedBox()),
              ],
            ),
            Spacer(),
            Transform.scale(
              scale: 2,
              child: MyTextButton(
                text: "Done",
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => MainPage()),
                    (route) => false,
                  );
                },
              ),
            ),
            SizedBox(height: defaultHeight * 10),
          ],
        ),
      ),
    );
  }
}
