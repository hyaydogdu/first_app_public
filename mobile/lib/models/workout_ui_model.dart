import 'package:first_app/models/workout_exercise_ui_model.dart';

const Object _notSet = Object();

// WorkoutUiModel, API'den gelen workout verisini temsil eder.
class WorkoutUiModel {
  final int id;
  final String name;
  final String? description;
  final bool isDefault;
  final DateTime createdAt;
  final List<WorkoutExerciseUiModel> workoutExercises;

  WorkoutUiModel({
    required this.id,
    required this.name,
    this.description,
    this.isDefault = false,
    required this.createdAt,
    required this.workoutExercises,
  });
  // API'den gelen JSON verisini WorkoutUiModel nesnesine dönüştürmek için factory constructor
  factory WorkoutUiModel.fromJson(Map<String, dynamic> json) {
    return WorkoutUiModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      isDefault: json['isDefault'] == true,
      createdAt: _parseCreatedAt(json['createdAt']),
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
      "createdAt": createdAt.toIso8601String(),
      "workoutExercises": workoutExercises.map((e) => e.toJson()).toList(),
    };
  }

  // Var olan bir WorkoutUiModel nesnesini güncellemek için copyWith metodu
  WorkoutUiModel copyWith({
    String? name,
    Object? description = _notSet,
    DateTime? createdAt,
    List<WorkoutExerciseUiModel>? workoutExercises,
  }) {
    return WorkoutUiModel(
      id: id,
      name: name ?? this.name,
      description: description == _notSet
          ? this.description
          : description as String?,
      isDefault: isDefault,
      createdAt: createdAt ?? this.createdAt,
      workoutExercises: workoutExercises ?? this.workoutExercises,
    );
  }

  static DateTime _parseCreatedAt(dynamic value) {
    if (value is String && value.isNotEmpty) {
      return DateTime.parse(value);
    }

    return DateTime.fromMillisecondsSinceEpoch(0);
  }
}
