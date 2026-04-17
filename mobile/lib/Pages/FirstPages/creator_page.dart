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
      appBar: AppBar(backgroundColor: color_1, elevation: 0),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          _sectionTitle("What do you want to create?"),
          const SizedBox(height: 8),

          CreateCard(
            text: "Create Workout",
            subtitle: "Design a new workout routine",
          ),
          const SizedBox(height: 12),

          CreateCard(
            text: "Create Weekly Plan",
            subtitle: "Organize your workouts for the week",
          ),
          const SizedBox(height: 28),

          _sectionTitle("Organize Your workouts"),
          const SizedBox(height: 8),

          CreateCard(
            text: "Create Workout Collection",
            subtitle: "Group your workouts into collections",
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(text, style: textStyleM),
    );
  }
}
