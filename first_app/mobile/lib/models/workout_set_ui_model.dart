class WorkoutSetUiModel {
  final int setIndex;
  final double weightKg;
  final int reps;
  final int restSeconds;

  WorkoutSetUiModel({
    required this.setIndex,
    required this.weightKg,
    required this.reps,
    required this.restSeconds,
  });

  factory WorkoutSetUiModel.fromJson(Map<String, dynamic> json) {
    return WorkoutSetUiModel(
      setIndex: json['setIndex'],
      weightKg: (json['weightKg'] as num).toDouble(),
      reps: (json['reps'] as num).toInt(),
      restSeconds: json['restSeconds'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "setIndex": setIndex,
      "weightKg": weightKg,
      "reps": reps,
      "restSeconds": restSeconds,
    };
  }

  WorkoutSetUiModel copyWith({
    int? setIndex,
    double? weightKg,
    int? reps,
    int? restSeconds,
  }) {
    return WorkoutSetUiModel(
      setIndex: setIndex ?? this.setIndex,
      weightKg: weightKg ?? this.weightKg,
      reps: reps ?? this.reps,
      restSeconds: restSeconds ?? this.restSeconds,
    );
  }
}
