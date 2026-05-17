enum ExerciseType { bodyweightBased, weightBased }

class ExerciseUiModel {
  final int id;
  final String name;
  final String? notes;
  final ExerciseType exerciseType;
  final String? imageUrl;
  final String? videoUrl;

  ExerciseUiModel({
    required this.id,
    required this.name,
    this.notes,
    this.exerciseType = ExerciseType.weightBased,
    this.imageUrl,
    this.videoUrl,
  });

  factory ExerciseUiModel.fromJson(Map<String, dynamic> json) {
    return ExerciseUiModel(
      id: json['id'],
      name: json['name'],
      notes: json['notes'],
      exerciseType: parseExerciseType(json['exerciseType']),
      imageUrl: json['imageUrl'],
      videoUrl: json['videoUrl'],
    );
  }
}

ExerciseType parseExerciseType(dynamic value) {
  return value == 'BodyweightBased'
      ? ExerciseType.bodyweightBased
      : ExerciseType.weightBased;
}
