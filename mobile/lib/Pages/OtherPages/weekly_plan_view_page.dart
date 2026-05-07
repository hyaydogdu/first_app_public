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
  bool editMode = false;
  late WeeklyPlanUiModel weeklyPlan;

  @override
  void initState() {
    super.initState();
    weeklyPlan = widget.weeklyPlan;
  }

  Future<void> _onWorkoutChanged(String day, WorkoutUiModel workout) async {
    setState(() {
      weeklyPlan = _copyWeeklyPlanWithDayWorkout(weeklyPlan, workout, day);
    });
  }

  Future<void> _save() async {
    await WeeklyPlanApi.updateWeeklyPlan(weeklyPlan);
  }

  Future<void> _toggleEditMode() async {
    {
      setState(() {
        editMode = true;
      });
    }
  }

  Future<void> _toggleViewMode() async {
    {
      setState(() {
        editMode = false;
        _save();
      });
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
          SizedBox(
            width: kToolbarHeight,
            height: kToolbarHeight,
            child: BarIconButton(
              buttonIcon: Icon(
                editMode ? Icons.check_rounded : Icons.edit_note_sharp,
              ),
              onPressed: editMode ? _toggleViewMode : _toggleEditMode,
            ),
          ),
        ],
      ),
      body: editMode
          ? _EditMode(
              weeklyPlan: weeklyPlan,
              onWorkoutChanged: _onWorkoutChanged,
            )
          : _ViewMode(weeklyPlan: weeklyPlan),
    );
  }
}

class _ViewMode extends StatelessWidget {
  final WeeklyPlanUiModel weeklyPlan;
  const _ViewMode({required this.weeklyPlan});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: defaultHeight),
        for (final day in _weekDays)
          WeekDayCard(day: day, weeklyPlan: weeklyPlan),
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
        SizedBox(height: defaultHeight),
        for (final day in _weekDays)
          WeekDayCardEdit(
            day: day,
            weeklyPlan: weeklyPlan,
            onWorkoutChanged: onWorkoutChanged,
          ),
      ],
    );
  }
}

const List<String> _weekDays = [
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday",
  "Saturday",
  "Sunday",
];

WeeklyPlanUiModel _copyWeeklyPlanWithDayWorkout(
  WeeklyPlanUiModel weeklyPlan,
  WorkoutUiModel workout,
  String day,
) {
  final week = weeklyPlan.week ?? WeekUiModel();

  final updatedWeek = switch (day) {
    "Monday" => week.copyWith(
      mondayWorkoutId: workout.id,
      mondayWorkout: workout,
    ),
    "Tuesday" => week.copyWith(
      tuesdayWorkoutId: workout.id,
      tuesdayWorkout: workout,
    ),
    "Wednesday" => week.copyWith(
      wednesdayWorkoutId: workout.id,
      wednesdayWorkout: workout,
    ),
    "Thursday" => week.copyWith(
      thursdayWorkoutId: workout.id,
      thursdayWorkout: workout,
    ),
    "Friday" => week.copyWith(
      fridayWorkoutId: workout.id,
      fridayWorkout: workout,
    ),
    "Saturday" => week.copyWith(
      saturdayWorkoutId: workout.id,
      saturdayWorkout: workout,
    ),
    "Sunday" => week.copyWith(
      sundayWorkoutId: workout.id,
      sundayWorkout: workout,
    ),
    _ => week,
  };

  return weeklyPlan.copyWith(week: updatedWeek);
}
