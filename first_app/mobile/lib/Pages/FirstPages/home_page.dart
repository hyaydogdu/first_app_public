import 'package:first_app/Services/weekly_plan_api.dart';
import 'package:first_app/models/weekly_plan_ui_model.dart';
import 'package:flutter/material.dart';
import 'package:first_app/Items/Barrel/item_barrel.dart';
import 'package:first_app/models/workout_ui_model.dart';
import 'package:first_app/services/workout_api.dart';

class HomePage extends DefaultPage {
  const HomePage({super.key});

  @override
  String get pageName => "Home";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<WorkoutUiModel> workouts = [];
  List<WeeklyPlanUiModel> weeklyPlans = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
    _loadWeeklyPlans();
  }

  Future<void> _loadWorkouts() async {
    try {
      final data = await WorkoutApi.getWorkouts();
      setState(() {
        workouts = data;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      // şimdilik debug
      debugPrint("API error: $e");
    }
  }

  Future<void> _loadWeeklyPlans() async {
    try {
      final plans = await WeeklyPlanApi.getWeeklyPlans();

      for (var p in plans) {
        debugPrint("ID: ${p.id}");
        debugPrint("NAME: ${p.name}");
      }

      setState(() {
        weeklyPlans = plans;
      });
    } catch (e) {
      debugPrint("WeeklyPlan API error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color_1,
      appBar: AppBar(backgroundColor: color_1),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.only(left: defaultHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Good Morning Halit ♣ ",
                  style: textStyleL.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  "Ready to train?",
                  style: textStyleM.copyWith(fontWeight: FontWeight.w100),
                ),
                SizedBox(height: defaultHeight),
              ],
            ),
          ),

          Row(
            children: [
              Expanded(child: StatCard(text: "did 2 workout in this week")),
              Expanded(child: StatCard(text: "12 workouts")),
            ],
          ),
          StatCard(text: "6h training time"),

          if (loading)
            const Padding(
              padding: EdgeInsets.all(12),
              child: Center(child: CircularProgressIndicator()),
            )
          else
            TodayWorkoutCard(
              workout: workouts.first,
              onCardClosed: _loadWorkouts,
            ),
          SizedBox(height: defaultHeight),

          if (loading) ...[
            const Padding(
              padding: EdgeInsets.all(12),
              child: Center(child: CircularProgressIndicator()),
            ),
            const Padding(
              padding: EdgeInsets.all(12),
              child: Center(child: CircularProgressIndicator()),
            ),
            const Padding(
              padding: EdgeInsets.all(12),
              child: Center(child: CircularProgressIndicator()),
            ),
          ] else ...[
            workoutSlider(
              title: "Ready Workouts",
              workouts: workouts,
              onCardClosed: _loadWorkouts,
            ),
            workoutSlider(
              title: "Ready Workouts",
              workouts: workouts,
              onCardClosed: _loadWorkouts,
            ),
          ],
          if (weeklyPlans.isNotEmpty) ...[
            WeeklyPlanCard(
              weeklyPlan: weeklyPlans.first,
              onCardClosed: _loadWeeklyPlans,
            ),
            Text(
              "Plan: ${weeklyPlans.first.name}",
              style: textStyleM,
              textAlign: TextAlign.center,
            ),

            Text(
              "Monday workout: ${weeklyPlans.first.week?.mondayWorkout?.name ?? '-'}",
              style: textStyleM,
              textAlign: TextAlign.center,
            ),
            Text(
              "Tuesday workout: ${weeklyPlans.first.week?.tuesdayWorkout?.name ?? '-'}",
              style: textStyleM,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
