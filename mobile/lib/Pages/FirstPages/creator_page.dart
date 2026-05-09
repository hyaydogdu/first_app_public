import 'package:flutter/material.dart';
import 'package:first_app/Items/Barrel/item_barrel.dart';

class CreatePage extends DefaultPage {
  const CreatePage({super.key});

  @override
  String get pageName => "Creator";

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color_1,
      appBar: AppBar(
        backgroundColor: color_1,
        title: Text("Creator Page", style: textStyleM),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          SizedBox(height: defaultHeight),
          _sectionTitle("What would you like to create?"),
          SizedBox(height: defaultHeight),
          CreateCard(
            subtitle: "Design a new workout routine",
            type: CreateType.workout,
          ),

          CreateCard(
            subtitle: "Organize your workouts for the week",
            type: CreateType.weeklyPlan,
          ),

          CreateCard(
            subtitle: "Group your workouts into collections",
            type: CreateType.workoutCollection,
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      child: Center(child: Text(text, style: textStyleM)),
    );
  }
}
