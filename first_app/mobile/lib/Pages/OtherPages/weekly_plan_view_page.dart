import 'package:first_app/Items/Barrel/item_barrel.dart';
import 'package:first_app/models/weekly_plan_ui_model.dart';
import 'package:flutter/material.dart';

class WeeklyPlanViewPage extends DefaultPage {
  final WeeklyPlanUiModel weeklyPlan;
  const WeeklyPlanViewPage({super.key, required this.weeklyPlan});

  @override
  String get pageName => "Weekly Plan View";

  @override
  State<WeeklyPlanViewPage> createState() => _WeeklyplanViewPageState();
}

class _WeeklyplanViewPageState extends State<WeeklyPlanViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color_1,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Weekly Plan", style: textStyleM),
        backgroundColor: color_1,
        elevation: 0,
        leading: BarIconButtons(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: [
          Text(
            "${widget.weeklyPlan.name.toUpperCase()} ",
            textAlign: TextAlign.center,
            style: textStyleL,
          ),
          WeekDayCard(day: "Monday", weeklyPlan: widget.weeklyPlan),
          WeekDayCard(day: "Tuesday", weeklyPlan: widget.weeklyPlan),
          WeekDayCard(day: "Wednesday", weeklyPlan: widget.weeklyPlan),
          WeekDayCard(day: "Thursday", weeklyPlan: widget.weeklyPlan),
          WeekDayCard(day: "Friday", weeklyPlan: widget.weeklyPlan),
          WeekDayCard(day: "Saturday", weeklyPlan: widget.weeklyPlan),
          WeekDayCard(day: "Sunday", weeklyPlan: widget.weeklyPlan),
        ],
      ),
    );
  }
}
