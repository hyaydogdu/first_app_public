import 'package:first_app/models/week_ui_model.dart';
import 'package:flutter/material.dart';

class WeeklyPlanUiModel {
  final int id;
  final String name;
  final String? description;
  final bool isDefault;
  final DateTime createdAt;
  final WeekUiModel? week;

  WeeklyPlanUiModel({
    required this.id,
    required this.name,
    this.description,
    this.isDefault = false,
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
      isDefault: json['isDefault'] == true,
      createdAt: DateTime.parse(json['createdAt']),
      week: week,
    );
  }

  WeeklyPlanUiModel copyWith({
    String? name,
    String? description,
    bool? isDefault,
    DateTime? createdAt,
    WeekUiModel? week,
  }) {
    return WeeklyPlanUiModel(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      week: week ?? this.week,
    );
  }
}
