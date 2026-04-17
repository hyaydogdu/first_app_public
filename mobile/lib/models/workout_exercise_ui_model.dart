import 'package:first_app/models/workout_set_ui_model.dart';

class WorkoutExerciseUiModel {
  final int id;
  final int exerciseId;
  final String exerciseName;
  final String? exerciseImageUrl;
  final String? videoUrl;
  final int orderIndex;
  final List<WorkoutSetUiModel> setList;

  WorkoutExerciseUiModel({
    required this.id,
    required this.exerciseId,
    required this.exerciseName,
    required this.orderIndex,
    this.exerciseImageUrl,
    this.videoUrl,
    required this.setList,
  });

  factory WorkoutExerciseUiModel.fromJson(Map<String, dynamic> json) {
    return WorkoutExerciseUiModel(
      id: json['id'],
      exerciseId: json['exerciseId'],
      exerciseName: json['exerciseName'],
      exerciseImageUrl: json['exerciseImageUrl'],
      videoUrl: json['videoUrl'],
      orderIndex: json['orderIndex'],
      setList: (json['sets'] as List<dynamic>)
          .map((e) => WorkoutSetUiModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // id > 0 ise update, değilse insert
      "id": id > 0 ? id : null,
      "exerciseId": exerciseId,
      "orderIndex": orderIndex,

      // Backend set listesini buradan okuyor
      "sets": setList.map((s) => s.toJson()).toList(),
    };
  }

  WorkoutExerciseUiModel copyWith({
    int? orderIndex,
    List<WorkoutSetUiModel>? setList,
  }) {
    return WorkoutExerciseUiModel(
      id: id,
      exerciseId: exerciseId,
      exerciseName: exerciseName,
      exerciseImageUrl: exerciseImageUrl,
      videoUrl: videoUrl,
      orderIndex: orderIndex ?? this.orderIndex,
      setList: setList ?? this.setList,
    );
  }
}
