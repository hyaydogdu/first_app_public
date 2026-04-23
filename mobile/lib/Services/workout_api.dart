import 'dart:convert';
import 'package:first_app/models/workout_exercise_ui_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import '../models/workout_ui_model.dart';

class WorkoutApi {
  static String get baseUrl => ApiConfig.endpoint('/api/workout');

  // GET - workout listesi
  static Future<List<WorkoutUiModel>> getWorkouts() async {
    final res = await http.get(Uri.parse(baseUrl));

    debugPrint("📡 GET /workouts status: ${res.statusCode}");
    debugPrint("📦 RESPONSE BODY:");
    debugPrint(res.body);

    if (res.statusCode != 200) {
      throw Exception("Get failed");
    }

    final List data = jsonDecode(res.body);
    return data.map((e) => WorkoutUiModel.fromJson(e)).toList();
  }

  // GET - id'ye göre workout
  static Future<WorkoutUiModel> getWorkoutById(int id) async {
    final res = await http.get(Uri.parse('$baseUrl/$id'));

    debugPrint("📡 GET /workout/$id status: ${res.statusCode}");
    debugPrint("📦 RESPONSE BODY:");
    debugPrint(res.body);

    if (res.statusCode != 200) {
      if (res.statusCode == 404) {
        throw Exception("Workout not found");
      }
      throw Exception("Failed to load workout");
    }

    final decoded = jsonDecode(res.body);

    if (decoded is! Map<String, dynamic>) {
      throw Exception("Invalid response format");
    }

    return WorkoutUiModel.fromJson(decoded);
  }

  // --------------------------------------
  // 1️⃣ UPDATE WORKOUT HEADER
  // --------------------------------------
  static Future<void> updateWorkoutHeader({
    required int id,
    required String name,
    String? description,
  }) async {
    final url = "$baseUrl/$id";

    final res = await http.put(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name, "description": description}),
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception("Update workout header failed");
    }
  }

  // --------------------------------------
  // 2️⃣ UPDATE WORKOUT EXERCISES (REPLACE)
  // --------------------------------------
  static Future<void> updateWorkoutExercises({
    required int workoutId,
    required List<WorkoutExerciseUiModel> exercises,
  }) async {
    final url = "$baseUrl/$workoutId/exercises";

    final res = await http.put(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "workoutExercises": exercises.map((e) => e.toJson()).toList(),
      }),
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception("Update workout exercises failed");
    }
  }

  static Future<void> deleteWorkout(int id) async {
    final url = "$baseUrl/$id";

    final res = await http.delete(Uri.parse(url));

    if (res.statusCode < 200 || res.statusCode >= 300) {
      debugPrint("❌ DELETE FAILED: ${res.statusCode}");
      debugPrint(res.body);
      throw Exception("Delete failed: ${res.statusCode}");
    }
  }

  static Future<void> deleteWorkoutExercise({
    required int workoutId,
    required int workoutExerciseId,
  }) async {
    final url = "$baseUrl/$workoutId/exercises/$workoutExerciseId";

    final res = await http.delete(Uri.parse(url));

    if (res.statusCode < 200 || res.statusCode >= 300) {
      debugPrint("❌ DELETE EXERCISE FAILED: ${res.statusCode}");
      debugPrint(res.body);
      throw Exception("Delete workout exercise failed");
    }
  }
}
