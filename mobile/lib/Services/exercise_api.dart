import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/exercise_ui_model.dart';

class ExerciseApi {
  static const String baseUrl = "http://10.0.2.2:5018/api/exercises";

  // GET - tüm exerciselar
  static Future<List<ExerciseUiModel>> getAllExercises() async {
    final res = await http.get(Uri.parse(baseUrl));

    debugPrint("📡 GET /exercises status: ${res.statusCode}");
    debugPrint("📦 RESPONSE BODY:");
    debugPrint(res.body);

    if (res.statusCode != 200) {
      throw Exception("Get exercises failed");
    }

    final List data = jsonDecode(res.body);
    return data.map((e) => ExerciseUiModel.fromJson(e)).toList();
  }
}
