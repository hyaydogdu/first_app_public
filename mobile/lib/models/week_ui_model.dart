import 'package:first_app/models/workout_ui_model.dart';

const Object _notSet = Object();

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

  WeekUiModel copyWith({
    Object? mondayWorkoutId = _notSet,
    Object? mondayWorkout = _notSet,
    Object? tuesdayWorkoutId = _notSet,
    Object? tuesdayWorkout = _notSet,
    Object? wednesdayWorkoutId = _notSet,
    Object? wednesdayWorkout = _notSet,
    Object? thursdayWorkoutId = _notSet,
    Object? thursdayWorkout = _notSet,
    Object? fridayWorkoutId = _notSet,
    Object? fridayWorkout = _notSet,
    Object? saturdayWorkoutId = _notSet,
    Object? saturdayWorkout = _notSet,
    Object? sundayWorkoutId = _notSet,
    Object? sundayWorkout = _notSet,
  }) {
    return WeekUiModel(
      mondayWorkoutId: mondayWorkoutId == _notSet
          ? this.mondayWorkoutId
          : mondayWorkoutId as int?,
      mondayWorkout: mondayWorkout == _notSet
          ? this.mondayWorkout
          : mondayWorkout as WorkoutUiModel?,
      tuesdayWorkoutId: tuesdayWorkoutId == _notSet
          ? this.tuesdayWorkoutId
          : tuesdayWorkoutId as int?,
      tuesdayWorkout: tuesdayWorkout == _notSet
          ? this.tuesdayWorkout
          : tuesdayWorkout as WorkoutUiModel?,
      wednesdayWorkoutId: wednesdayWorkoutId == _notSet
          ? this.wednesdayWorkoutId
          : wednesdayWorkoutId as int?,
      wednesdayWorkout: wednesdayWorkout == _notSet
          ? this.wednesdayWorkout
          : wednesdayWorkout as WorkoutUiModel?,
      thursdayWorkoutId: thursdayWorkoutId == _notSet
          ? this.thursdayWorkoutId
          : thursdayWorkoutId as int?,
      thursdayWorkout: thursdayWorkout == _notSet
          ? this.thursdayWorkout
          : thursdayWorkout as WorkoutUiModel?,
      fridayWorkoutId: fridayWorkoutId == _notSet
          ? this.fridayWorkoutId
          : fridayWorkoutId as int?,
      fridayWorkout: fridayWorkout == _notSet
          ? this.fridayWorkout
          : fridayWorkout as WorkoutUiModel?,
      saturdayWorkoutId: saturdayWorkoutId == _notSet
          ? this.saturdayWorkoutId
          : saturdayWorkoutId as int?,
      saturdayWorkout: saturdayWorkout == _notSet
          ? this.saturdayWorkout
          : saturdayWorkout as WorkoutUiModel?,
      sundayWorkoutId: sundayWorkoutId == _notSet
          ? this.sundayWorkoutId
          : sundayWorkoutId as int?,
      sundayWorkout: sundayWorkout == _notSet
          ? this.sundayWorkout
          : sundayWorkout as WorkoutUiModel?,
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
