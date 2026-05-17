import 'package:first_app/Items/Barrel/item_barrel.dart';
import 'package:first_app/Services/weekly_plan_api.dart';
import 'package:first_app/Services/workout_api.dart';
import 'package:first_app/models/week_ui_model.dart';
import 'package:first_app/models/weekly_plan_ui_model.dart';
import 'package:first_app/models/workout_ui_model.dart';
import 'package:flutter/material.dart';

class WeeklyPlanPage extends DefaultPage {
  final WeeklyPlanUiModel weeklyPlan;
  const WeeklyPlanPage({super.key, required this.weeklyPlan});

  @override
  String get pageName => "Weekly Plan View";

  @override
  State<WeeklyPlanPage> createState() => _WeeklyplanViewPageState();
}

class _WeeklyplanViewPageState extends State<WeeklyPlanPage> {
  bool editMode = false;
  late WeeklyPlanUiModel weeklyPlan;

  @override
  void initState() {
    super.initState();
    weeklyPlan = widget.weeklyPlan;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadWeeklyPlanDetails();
    });
  }

  Future<void> _onWorkoutChanged(String day, WorkoutUiModel? workout) async {
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
    await _save();
    await _loadWeeklyPlanDetails();

    if (!mounted) return;

    setState(() {
      editMode = false;
    });
  }

  void _deleteWeeklyPlan() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Weekly Plan"),
        content: Text("Are you sure you want to delete this weekly plan?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (!mounted) return;

    if (confirm != true) return;

    try {
      await WeeklyPlanApi.deleteWeeklyPlan(widget.weeklyPlan.id);

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Delete failed")));
    }
  }

  Future<void> _loadWeeklyPlanDetails() async {
    try {
      final updatedPlan = await WeeklyPlanApi.getWeeklyPlanById(weeklyPlan.id);
      if (!mounted) return;

      setState(() {
        weeklyPlan = updatedPlan;
      });
    } catch (e) {
      debugPrint("Failed to refresh weekly plan: $e");
    }
  }

  Future<void> _refreshDayWorkout(String day, WorkoutUiModel workout) async {
    try {
      final updatedWorkout = await WorkoutApi.getWorkoutById(workout.id);
      if (!mounted) return;

      setState(() {
        weeklyPlan = _copyWeeklyPlanWithDayWorkout(
          weeklyPlan,
          updatedWorkout,
          day,
        );
        _loadWeeklyPlanDetails();
      });
    } catch (e) {
      debugPrint("Failed to refresh day workout: $e");
      await _loadWeeklyPlanDetails();
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
          if (!widget.weeklyPlan.isDefault) ...[
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
            SizedBox(
              width: kToolbarHeight,
              height: kToolbarHeight,
              child: BarIconButton(
                buttonIcon: Icon(Icons.delete_rounded),
                onPressed: _deleteWeeklyPlan,
              ),
            ),
          ],
        ],
      ),
      body: editMode
          ? _EditMode(
              weeklyPlan: weeklyPlan,
              onWorkoutChanged: _onWorkoutChanged,
              onWorkoutClosed: _refreshDayWorkout,
            )
          : _ViewMode(
              weeklyPlan: weeklyPlan,
              onWorkoutClosed: _refreshDayWorkout,
            ),
    );
  }
}

class _ViewMode extends StatelessWidget {
  final WeeklyPlanUiModel weeklyPlan;
  final Future<void> Function(String day, WorkoutUiModel workout)
  onWorkoutClosed;

  const _ViewMode({required this.weeklyPlan, required this.onWorkoutClosed});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _Header(weeklyPlan),
        for (final day in _weekDays)
          WeekDayCard(
            day: day,
            weeklyPlan: weeklyPlan,
            onWorkoutClosed: onWorkoutClosed,
          ),
      ],
    );
  }
}

class _EditMode extends StatelessWidget {
  final WeeklyPlanUiModel weeklyPlan;
  final Future<void> Function(String day, WorkoutUiModel? workout)
  onWorkoutChanged;
  final Future<void> Function(String day, WorkoutUiModel workout)
  onWorkoutClosed;

  const _EditMode({
    required this.weeklyPlan,
    required this.onWorkoutChanged,
    required this.onWorkoutClosed,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _Header(weeklyPlan),
        for (final day in _weekDays)
          WeekDayCardEdit(
            day: day,
            weeklyPlan: weeklyPlan,
            onWorkoutChanged: onWorkoutChanged,
            onWorkoutClosed: onWorkoutClosed,
          ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final WeeklyPlanUiModel weeklyPlan;
  const _Header(this.weeklyPlan);

  @override
  Widget build(BuildContext context) {
    return Box(
      boxColor: color_2,
      softCorners: true,
      edgeSpaceHorizontal: true,
      edgeSpaceAllSmall: true,
      child: Box(
        boxColor: color_2,
        edgeSpaceAllBig: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              textCase("${weeklyPlan.name} program", TextCaseMode.title),
              style: textStyleM,
              textAlign: TextAlign.start,
            ),
            SizedBox(height: defaultHeight),
            Text(
              "Stay consistent and keep training",
              style: textStyleSGrey,
              textAlign: TextAlign.start,
            ),
            SizedBox(height: defaultHeight),
            Box(
              boxColor: color_1,
              softCorners: true,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text("Active Days", style: textStyleSGrey),
                        Text(
                          "${_activeDays(weeklyPlan).toString()}/7",
                          style: textStyleM,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: defaultHeight * 4,
                    child: VerticalDivider(thickness: 3, color: color_2),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text("Exercises", style: textStyleSGrey),
                        Text(
                          _totalExercises(weeklyPlan).toString(),
                          style: textStyleM,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: defaultHeight * 4,
                    child: VerticalDivider(thickness: 3, color: color_2),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text("Sets", style: textStyleSGrey),
                        Text(
                          _totalSets(weeklyPlan).toString(),
                          style: textStyleM,
                        ),
                      ],
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

int _activeDays(WeeklyPlanUiModel plan) {
  final week = plan.week;
  if (week == null) return 0;

  return [
    week.mondayWorkoutId ?? week.mondayWorkout?.id,
    week.tuesdayWorkoutId ?? week.tuesdayWorkout?.id,
    week.wednesdayWorkoutId ?? week.wednesdayWorkout?.id,
    week.thursdayWorkoutId ?? week.thursdayWorkout?.id,
    week.fridayWorkoutId ?? week.fridayWorkout?.id,
    week.saturdayWorkoutId ?? week.saturdayWorkout?.id,
    week.sundayWorkoutId ?? week.sundayWorkout?.id,
  ].where((id) => id != null).length;
}

int _totalExercises(WeeklyPlanUiModel plan) {
  return _workoutsInPlan(
    plan,
  ).fold<int>(0, (total, workout) => total + workout.workoutExercises.length);
}

int _totalSets(WeeklyPlanUiModel plan) {
  return _workoutsInPlan(plan).fold<int>(
    0,
    (total, workout) =>
        total +
        workout.workoutExercises.fold<int>(
          0,
          (exerciseTotal, exercise) => exerciseTotal + exercise.setList.length,
        ),
  );
}

List<WorkoutUiModel> _workoutsInPlan(WeeklyPlanUiModel plan) {
  final week = plan.week;
  if (week == null) return [];

  return [
    week.mondayWorkout,
    week.tuesdayWorkout,
    week.wednesdayWorkout,
    week.thursdayWorkout,
    week.fridayWorkout,
    week.saturdayWorkout,
    week.sundayWorkout,
  ].whereType<WorkoutUiModel>().toList();
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
  WorkoutUiModel? workout,
  String day,
) {
  final week = weeklyPlan.week ?? WeekUiModel();

  final updatedWeek = switch (day) {
    "Monday" => week.copyWith(
      mondayWorkoutId: workout?.id,
      mondayWorkout: workout,
    ),

    "Tuesday" => week.copyWith(
      tuesdayWorkoutId: workout?.id,
      tuesdayWorkout: workout,
    ),

    "Wednesday" => week.copyWith(
      wednesdayWorkoutId: workout?.id,
      wednesdayWorkout: workout,
    ),

    "Thursday" => week.copyWith(
      thursdayWorkoutId: workout?.id,
      thursdayWorkout: workout,
    ),

    "Friday" => week.copyWith(
      fridayWorkoutId: workout?.id,
      fridayWorkout: workout,
    ),

    "Saturday" => week.copyWith(
      saturdayWorkoutId: workout?.id,
      saturdayWorkout: workout,
    ),

    "Sunday" => week.copyWith(
      sundayWorkoutId: workout?.id,
      sundayWorkout: workout,
    ),

    _ => week,
  };

  return weeklyPlan.copyWith(week: updatedWeek);
}
