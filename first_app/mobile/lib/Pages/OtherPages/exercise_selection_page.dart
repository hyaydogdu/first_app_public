import 'package:first_app/Items/Barrel/item_barrel.dart';
import 'package:first_app/Services/exercise_api.dart';
import 'package:first_app/models/exercise_ui_model.dart';
import 'package:flutter/material.dart';

class ExerciseSelectionPage extends StatelessWidget {
  const ExerciseSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color_1,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: color_2,
        elevation: 0,
        leading: Center(
          child: BarIconButtons(onPressed: () => Navigator.pop(context)),
        ),
      ),
      body: Column(
        children: [
          CreateCard(text: "Bench Press Example"),
          FutureBuilder<List<ExerciseUiModel>>(
            future: ExerciseApi.getAllExercises(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Center(child: Text("Hata oluştu"));
              }

              final exercises = snapshot.data ?? [];

              return ViewExercises(exercises: exercises);
            },
          ),
        ],
      ),
    );
  }
}

class ViewExercises extends StatelessWidget {
  final List<ExerciseUiModel> exercises;

  const ViewExercises({super.key, required this.exercises});

  @override
  Widget build(BuildContext context) {
    return BorderBox(
      boxColor: color_1,
      child: SizedBox(
        height: 400,
        child: exercises.isEmpty
            ? const Center(child: Text("Exercise yok"))
            : ListView.builder(
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  final exercise = exercises[index];
                  return SelectExerciseCard(exercise: exercise);
                },
              ),
      ),
    );
  }
}
