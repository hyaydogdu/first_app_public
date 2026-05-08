import 'package:first_app/models/workout_ui_model.dart';
import 'package:first_app/services/workout_api.dart';
import 'package:flutter/material.dart';
import '../../Items/Barrel/item_barrel.dart';

enum SelectWorkoutResult { restDay }

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
              ViewWorkouts(workouts: workouts),
            ],
          );
        },
      ),
    );
  }
}

class ViewWorkouts extends StatelessWidget {
  final List<WorkoutUiModel> workouts;

  const ViewWorkouts({super.key, required this.workouts});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Box(
        boxColor: color_1,
        child: workouts.isEmpty
            ? const Center(child: Text("Workout yok"))
            : ListView.builder(
                itemCount: workouts.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _RestCard();
                  }
                  final workout = workouts[index - 1];
                  return SelectWorkoutCard(
                    workout: workout,
                    onViewWorkout: () => Navigator.pop(context, workout),
                  );
                },
              ),
      ),
    );
  }
}

class _RestCard extends StatelessWidget {
  const _RestCard();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context, SelectWorkoutResult.restDay),
      child: BorderBox(
        boxColor: accentColor,
        softCorners: true,
        edgeSpaceAllBig: true,
        elevation: 4,
        child: maxWidth(
          child: cardPart(
            height: defaultHeight * 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Rest Day", style: textStyleM),
                Text("Enjoy Your Day", style: textStyleSGrey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
