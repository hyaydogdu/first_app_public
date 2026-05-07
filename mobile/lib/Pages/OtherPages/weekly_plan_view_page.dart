import 'package:first_app/Items/Barrel/item_barrel.dart';
import 'package:first_app/Services/weekly_plan_api.dart';
import 'package:first_app/models/week_ui_model.dart';
import 'package:first_app/models/weekly_plan_ui_model.dart';
import 'package:first_app/models/workout_ui_model.dart';
import 'package:flutter/material.dart';

class WeeklyPlanViewPage extends DefaultPage {
  final WeeklyPlanUiModel weeklyPlan;
  const WeeklyPlanViewPage({super.key, required this.weeklyPlan});

  @override
  String get pageName => "Weekly Plan View";

  @override
  State<WeeklyPlanViewPage> createState() => _WeeklyplanViewPageState();
}

class _WeeklyplanViewPageState extends State<WeeklyPlanViewPage> {
  bool isEditing = false;
  late WeeklyPlanUiModel currentWeeklyPlan;
  late WeeklyPlanUiModel editedWeeklyPlan;

  @override
  void initState() {
    super.initState();
    currentWeeklyPlan = widget.weeklyPlan;
    editedWeeklyPlan = widget.weeklyPlan;
  }

  Future<void> _save() async {
    // Kaydetme işlemi burada yapılır (örneğin, veritabanına kaydetme)
    // Bu örnekte sadece düzenleme modunu kapatıyoruz
    setState(() {
      currentWeeklyPlan = editedWeeklyPlan;
      isEditing = false;
    });
  }

  void _startEditing() {
    setState(() {
      editedWeeklyPlan = currentWeeklyPlan;
      isEditing = true;
    });
  }

  Future<void> _changeDayWorkout(String day, WorkoutUiModel workout) async {
    final previousEditedWeeklyPlan = editedWeeklyPlan;

    setState(() {
      editedWeeklyPlan = _copyWeeklyPlanWithDayWorkout(
        editedWeeklyPlan,
        day,
        workout,
      );
    });

    try {
      await WeeklyPlanApi.assignWorkoutToDay(
        weeklyPlanId: editedWeeklyPlan.id,
        day: day,
        workoutId: workout.id,
      );
    } catch (e) {
      debugPrint("Failed to change weekly plan workout: $e");
      if (!mounted) return;
      setState(() {
        editedWeeklyPlan = previousEditedWeeklyPlan;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Workout değiştirilemedi")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color_1,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Weekly Plan", style: textStyleM),
        backgroundColor: color_1,
        elevation: 0,
        leading: BarIconButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          if (!currentWeeklyPlan.isDefault)
            SizedBox(
              width: kToolbarHeight,
              height: kToolbarHeight,
              child: BarIconButton(
                buttonIcon: Icon(
                  isEditing ? Icons.check_rounded : Icons.edit_note_sharp,
                ),
                onPressed: () async {
                  if (isEditing) {
                    await _save();
                  } else {
                    _startEditing();
                  }
                },
              ),
            ),
        ],
      ),
      body: isEditing
          ? _EditMode(
              weeklyPlan: editedWeeklyPlan,
              onWorkoutChanged: _changeDayWorkout,
            )
          : _ViewMode(weeklyPlan: currentWeeklyPlan),
    );
  }
}

WeeklyPlanUiModel _copyWeeklyPlanWithDayWorkout(
  WeeklyPlanUiModel weeklyPlan,
  String day,
  WorkoutUiModel workout,
) {
  final week = weeklyPlan.week ?? WeekUiModel();

  switch (day) {
    case "Monday":
      return weeklyPlan.copyWith(
        week: week.copyWith(mondayWorkoutId: workout.id, mondayWorkout: workout),
      );
    case "Tuesday":
      return weeklyPlan.copyWith(
        week: week.copyWith(
          tuesdayWorkoutId: workout.id,
          tuesdayWorkout: workout,
        ),
      );
    case "Wednesday":
      return weeklyPlan.copyWith(
        week: week.copyWith(
          wednesdayWorkoutId: workout.id,
          wednesdayWorkout: workout,
        ),
      );
    case "Thursday":
      return weeklyPlan.copyWith(
        week: week.copyWith(
          thursdayWorkoutId: workout.id,
          thursdayWorkout: workout,
        ),
      );
    case "Friday":
      return weeklyPlan.copyWith(
        week: week.copyWith(fridayWorkoutId: workout.id, fridayWorkout: workout),
      );
    case "Saturday":
      return weeklyPlan.copyWith(
        week: week.copyWith(
          saturdayWorkoutId: workout.id,
          saturdayWorkout: workout,
        ),
      );
    case "Sunday":
      return weeklyPlan.copyWith(
        week: week.copyWith(sundayWorkoutId: workout.id, sundayWorkout: workout),
      );
    default:
      return weeklyPlan;
  }
}

class _ViewMode extends StatelessWidget {
  final WeeklyPlanUiModel weeklyPlan;
  const _ViewMode({required this.weeklyPlan});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text(
          textCase(weeklyPlan.name, TextCaseMode.title),
          textAlign: TextAlign.center,
          style: textStyleXL,
        ),
        WeekDayCard(day: "Monday", weeklyPlan: weeklyPlan),
        WeekDayCard(day: "Tuesday", weeklyPlan: weeklyPlan),
        WeekDayCard(day: "Wednesday", weeklyPlan: weeklyPlan),
        WeekDayCard(day: "Thursday", weeklyPlan: weeklyPlan),
        WeekDayCard(day: "Friday", weeklyPlan: weeklyPlan),
        WeekDayCard(day: "Saturday", weeklyPlan: weeklyPlan),
        WeekDayCard(day: "Sunday", weeklyPlan: weeklyPlan),
      ],
    );
  }
}

class _EditMode extends StatelessWidget {
  final WeeklyPlanUiModel weeklyPlan;
  final Future<void> Function(String day, WorkoutUiModel workout)
  onWorkoutChanged;

  const _EditMode({required this.weeklyPlan, required this.onWorkoutChanged});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text(
          textCase(weeklyPlan.name, TextCaseMode.title),
          textAlign: TextAlign.center,
          style: textStyleXL,
        ),
        WeekDayCardEdit(
          day: "Monday",
          weeklyPlan: weeklyPlan,
          onWorkoutChanged: onWorkoutChanged,
        ),
        WeekDayCardEdit(
          day: "Tuesday",
          weeklyPlan: weeklyPlan,
          onWorkoutChanged: onWorkoutChanged,
        ),
        WeekDayCardEdit(
          day: "Wednesday",
          weeklyPlan: weeklyPlan,
          onWorkoutChanged: onWorkoutChanged,
        ),
        WeekDayCardEdit(
          day: "Thursday",
          weeklyPlan: weeklyPlan,
          onWorkoutChanged: onWorkoutChanged,
        ),
        WeekDayCardEdit(
          day: "Friday",
          weeklyPlan: weeklyPlan,
          onWorkoutChanged: onWorkoutChanged,
        ),
        WeekDayCardEdit(
          day: "Saturday",
          weeklyPlan: weeklyPlan,
          onWorkoutChanged: onWorkoutChanged,
        ),
        WeekDayCardEdit(
          day: "Sunday",
          weeklyPlan: weeklyPlan,
          onWorkoutChanged: onWorkoutChanged,
        ),
      ],
    );
  }
}
