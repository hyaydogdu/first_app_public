import 'package:first_app/models/workout_ui_model.dart';

class WeekUiModel {
  final int? mondayWorkoutId;
  final WorkoutUiModel? mondayWorkout;
  final int? tuesdayWorkoutId;
  final WorkoutUiModel? tuesdayWorkout;
  final int? wednesdayWorkoutId;
  final WorkoutUiModel? wednesdayWorkout;
  final int? thursdayWorkoutId;
  final WorkoutUiModel? thursdayWorkout;
  final int? fridayWorkoutId;
  final WorkoutUiModel? fridayWorkout;
  final int? saturdayWorkoutId;
  final WorkoutUiModel? saturdayWorkout;
  final int? sundayWorkoutId;
  final WorkoutUiModel? sundayWorkout;

  WeekUiModel({
    this.mondayWorkoutId,
    this.mondayWorkout,
    this.tuesdayWorkoutId,
    this.tuesdayWorkout,
    this.wednesdayWorkoutId,
    this.wednesdayWorkout,
    this.thursdayWorkoutId,
    this.thursdayWorkout,
    this.fridayWorkoutId,
    this.fridayWorkout,
    this.saturdayWorkoutId,
    this.saturdayWorkout,
    this.sundayWorkoutId,
    this.sundayWorkout,
  });

  factory WeekUiModel.fromJson(Map<String, dynamic> json) {
    final mondayJson = _workoutJson(json, 'monday');
    final tuesdayJson = _workoutJson(json, 'tuesday');
    final wednesdayJson = _workoutJson(json, 'wednesday');
    final thursdayJson = _workoutJson(json, 'thursday');
    final fridayJson = _workoutJson(json, 'friday');
    final saturdayJson = _workoutJson(json, 'saturday');
    final sundayJson = _workoutJson(json, 'sunday');

    return WeekUiModel(
      mondayWorkoutId: json['mondayWorkoutId'] ?? mondayJson?['id'],
      mondayWorkout: _parseWorkout(mondayJson),
      tuesdayWorkoutId: json['tuesdayWorkoutId'] ?? tuesdayJson?['id'],
      tuesdayWorkout: _parseWorkout(tuesdayJson),
      wednesdayWorkoutId: json['wednesdayWorkoutId'] ?? wednesdayJson?['id'],
      wednesdayWorkout: _parseWorkout(wednesdayJson),
      thursdayWorkoutId: json['thursdayWorkoutId'] ?? thursdayJson?['id'],
      thursdayWorkout: _parseWorkout(thursdayJson),
      fridayWorkoutId: json['fridayWorkoutId'] ?? fridayJson?['id'],
      fridayWorkout: _parseWorkout(fridayJson),
      saturdayWorkoutId: json['saturdayWorkoutId'] ?? saturdayJson?['id'],
      saturdayWorkout: _parseWorkout(saturdayJson),
      sundayWorkoutId: json['sundayWorkoutId'] ?? sundayJson?['id'],
      sundayWorkout: _parseWorkout(sundayJson),
    );
  }

  static Map<String, dynamic>? _workoutJson(
    Map<String, dynamic> json,
    String day,
  ) {
    final pascalDay = '${day[0].toUpperCase()}${day.substring(1)}';
    final value = json[day] ?? json[pascalDay] ?? json['${day}Workout'];

    if (value is Map<String, dynamic>) {
      return value;
    }

    return null;
  }

  static WorkoutUiModel? _parseWorkout(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }

    return WorkoutUiModel.fromJson(json);
  }
}
