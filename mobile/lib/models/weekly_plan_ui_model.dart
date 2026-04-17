import 'package:first_app/models/week_ui_model.dart';
import 'package:flutter/material.dart';

class WeeklyPlanUiModel {
  final int id;
  final String name;
  final String? description;
  final DateTime createdAt;
  final WeekUiModel? week;

  WeeklyPlanUiModel({
    required this.id,
    required this.name,
    this.description,
    required this.createdAt,
    this.week,
  });

  factory WeeklyPlanUiModel.fromJson(Map<String, dynamic> json) {
    debugPrint("WeeklyPlan fromJson: $json");

    final week = json['week'] != null
        ? WeekUiModel.fromJson(json['week'] as Map<String, dynamic>)
        : null;

    return WeeklyPlanUiModel(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      week: week,
    );
  }
}
