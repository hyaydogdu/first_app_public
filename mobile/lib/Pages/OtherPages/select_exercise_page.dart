import 'package:first_app/Items/Barrel/item_barrel.dart';
import 'package:first_app/Services/exercise_api.dart';
import 'package:first_app/models/exercise_ui_model.dart';
import 'package:flutter/material.dart';

class ExerciseSelectionPage extends StatefulWidget {
  const ExerciseSelectionPage({super.key});

  @override
  State<ExerciseSelectionPage> createState() => _ExerciseSelectionPageState();
}

class _ExerciseSelectionPageState extends State<ExerciseSelectionPage> {
  late Future<List<ExerciseUiModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = ExerciseApi.getAllExercises();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color_1,
      appBar: AppBar(
        backgroundColor: color_1,
        title: Text("Select Exercise", style: textStyleM),
        centerTitle: true,
        leading: BarIconButton(onPressed: () => Navigator.pop(context)),
      ),
      body: FutureBuilder<List<ExerciseUiModel>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error loading exercises"));
          }

          final exercises = snapshot.data ?? [];

          return Column(
            children: [
              Text(
                "${exercises.length} exercises available",
                style: textStyleM,
              ),
              SizedBox(height: defaultHeight),
              ViewExercises(exercises: exercises),
            ],
          );
        },
      ),
    );
  }
}

class ViewExercises extends StatelessWidget {
  final List<ExerciseUiModel> exercises;

  const ViewExercises({super.key, required this.exercises});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Box(
        boxColor: color_2,
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
