import 'package:first_app/models/workout_ui_model.dart';
import 'package:first_app/services/workout_api.dart';
import 'package:flutter/material.dart';
import '../../Items/Barrel/item_barrel.dart';

class SelectWorkoutPage extends StatefulWidget {
  const SelectWorkoutPage({super.key});

  @override
  State<SelectWorkoutPage> createState() => _SelectWorkoutPageState();
}

class _SelectWorkoutPageState extends State<SelectWorkoutPage> {
  late Future<List<WorkoutUiModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = WorkoutApi.getWorkouts();
  }

  Future<void> _selectWorkout(WorkoutUiModel workout) async {
    try {
      final selectedWorkout = await WorkoutApi.getWorkoutById(workout.id);
      if (!mounted) return;
      Navigator.pop(context, selectedWorkout);
    } catch (e) {
      debugPrint("Failed to load selected workout details: $e");
      if (!mounted) return;
      Navigator.pop(context, workout);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color_1,
      appBar: AppBar(
        backgroundColor: color_1,
        title: Text("Select Workout"),
        centerTitle: true,
        leading: BarIconButton(onPressed: () => Navigator.pop(context)),
      ),
      body: FutureBuilder<List<WorkoutUiModel>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error loading workouts"));
          }

          final workouts = snapshot.data ?? [];
          return Column(
            children: [
              SizedBox(height: defaultHeight),
              ViewWorkouts(workouts: workouts, onViewWorkout: _selectWorkout),
            ],
          );
        },
      ),
    );
  }
}

class ViewWorkouts extends StatelessWidget {
  final List<WorkoutUiModel> workouts;
  final ValueChanged<WorkoutUiModel> onViewWorkout;

  const ViewWorkouts({
    super.key,
    required this.workouts,
    required this.onViewWorkout,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Box(
        boxColor: color_1,
        child: workouts.isEmpty
            ? const Center(child: Text("Workout yok"))
            : ListView.builder(
                itemCount: workouts.length,
                itemBuilder: (context, index) {
                  final workout = workouts[index];
                  return SelectWorkoutCard(
                    workout: workout,
                    onViewWorkout: () => onViewWorkout(workout),
                  );
                },
              ),
      ),
    );
  }
}
