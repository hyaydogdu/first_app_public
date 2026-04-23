class ExerciseUiModel {
  final int id;
  final String name;
  final String? notes;
  final String? imageUrl;
  final String? videoUrl;

  ExerciseUiModel({
    required this.id,
    required this.name,
    this.notes,
    this.imageUrl,
    this.videoUrl,
  });

  factory ExerciseUiModel.fromJson(Map<String, dynamic> json) {
    return ExerciseUiModel(
      id: json['id'],
      name: json['name'],
      notes: json['notes'],
      imageUrl: json['imageUrl'],
      videoUrl: json['videoUrl'],
    );
  }
}
