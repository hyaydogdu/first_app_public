import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/weekly_plan_ui_model.dart';

class WeeklyPlanApi {
  static const String baseUrl = "http://10.0.2.2:5018/api/weeklyplans";

  static Future<List<WeeklyPlanUiModel>> getWeeklyPlans() async {
    debugPrint("🚀 getWeeklyPlans başladı");

    final res = await http.get(Uri.parse(baseUrl));

    debugPrint("🔥 📡 STATUS: ${res.statusCode}");
    debugPrint("🔥 📦 BODY:");
    debugPrint(res.body);

    if (res.statusCode != 200) {
      throw Exception("Failed: ${res.statusCode}");
    }

    final decoded = jsonDecode(res.body);

    debugPrint("✅ json decode tamam");
    debugPrint("TYPE: ${decoded.runtimeType}");
    debugPrint("RAW LENGTH: ${(decoded as List).length}");

    final plans = decoded
        .map<WeeklyPlanUiModel>(
          (e) => WeeklyPlanUiModel.fromJson(e as Map<String, dynamic>),
        )
        .toList();

    debugPrint("✅ PARSED LENGTH: ${plans.length}");

    for (final p in plans) {
      debugPrint("PLAN NAME: ${p.name}");
    }

    return plans;
  }
}
