import 'package:first_app/models/workout_exercise_ui_model.dart';

// WorkoutUiModel, API'den gelen workout verisini temsil eder.
class WorkoutUiModel {
  final int id;
  final String name;
  final String? description;
  final List<WorkoutExerciseUiModel> workoutExercises;

  WorkoutUiModel({
    required this.id,
    required this.name,
    this.description,
    required this.workoutExercises,
  });
  // API'den gelen JSON verisini WorkoutUiModel nesnesine dönüştürmek için factory constructor
  factory WorkoutUiModel.fromJson(Map<String, dynamic> json) {
    return WorkoutUiModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      workoutExercises: (json['workoutExercises'] as List<dynamic>? ?? [])
          .map((e) => WorkoutExerciseUiModel.fromJson(e))
          .toList(),
    );
  }

  // API'ye gönderirken JSON formatına dönüştürmek için
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "workoutExercises": workoutExercises.map((e) => e.toJson()).toList(),
    };
  }

  // Var olan bir WorkoutUiModel nesnesini güncellemek için copyWith metodu
  WorkoutUiModel copyWith({
    String? name,
    String? description,
    List<WorkoutExerciseUiModel>? workoutExercises,
  }) {
    return WorkoutUiModel(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      workoutExercises: workoutExercises ?? this.workoutExercises,
    );
  }
}
