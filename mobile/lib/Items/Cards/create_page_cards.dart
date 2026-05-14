// import 'package:first_app/Pages/Barrel/page_barrel.dart';
import 'package:first_app/Pages/Barrel/page_barrel.dart';
import 'package:first_app/Services/weekly_plan_api.dart';
import 'package:first_app/Services/workout_api.dart';
import 'package:flutter/material.dart';
import 'package:first_app/Items/Barrel/item_barrel.dart';

enum CreateType { workout, weeklyPlan, workoutCollection }

class CreateCard extends StatelessWidget {
  final CreateType type;
  final String? subtitle;
  final Icon? cardIcon;
  const CreateCard({
    super.key,
    this.subtitle,
    this.cardIcon,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    String questionText = textCase(
      "Would you like to create \n${type.name.splitMapJoin(RegExp(r'(?=[A-Z])'), onMatch: (m) => ' ')}?",
      TextCaseMode.sentence,
    );
    String buttonText = textCase(
      "Create ${type.name.splitMapJoin(RegExp(r'(?=[A-Z])'), onMatch: (m) => ' ')}",
      TextCaseMode.sentence,
    );
    return Box(
      boxColor: color_2,
      softCorners: true,
      edgeSpaceAllSmall: true,
      edgeSpaceHorizontal: true,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(questionText, style: textStyleM, textAlign: TextAlign.start),
            SizedBox(height: defaultHeight / 2),

            if (subtitle != null) ...[
              Text(subtitle!, style: textStyleS, textAlign: TextAlign.start),
              SizedBox(height: defaultHeight / 2),
            ],
            maxWidth(
              child: MyTextButton(
                text: buttonText,
                onPressed: () async {
                  // final result =
                  try {
                    final result = await _create(type, context);
                    if (!context.mounted || result == null) return;

                    switch (type) {
                      case CreateType.workout:
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                WorkoutViewPage(workout: result),
                          ),
                        );
                        break;

                      case CreateType.weeklyPlan:
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                WeeklyPlanPage(weeklyPlan: result),
                          ),
                        );
                        break;
                      case CreateType.workoutCollection:
                        // No action for now
                        break;
                    }
                  } catch (error) {
                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Create failed: $error")),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<dynamic> _create(CreateType type, BuildContext context) async {
  final name = await showDialog<String>(
    context: context,
    builder: (dialogContext) => _CreateNameDialog(title: _getCreateTitle(type)),
  );

  if (name == null || name.isEmpty) return null;

  switch (type) {
    case CreateType.workout:
      final workouts = await WorkoutApi.getWorkouts();
      final availableName = _getAvailableName(
        name,
        workouts.map((workout) => workout.name),
      );
      final workout = await WorkoutApi.createWorkout(name: availableName);
      return workout;

    case CreateType.weeklyPlan:
      final weeklyPlans = await WeeklyPlanApi.getWeeklyPlans();
      final availableName = _getAvailableName(
        name,
        weeklyPlans.map((weeklyPlan) => weeklyPlan.name),
      );
      final weeklyPlan = await WeeklyPlanApi.createWeeklyPlan(
        name: availableName,
        description: "Description",
      );
      return weeklyPlan;

    case CreateType.workoutCollection:
      return null;
  }
}

class _CreateNameDialog extends StatefulWidget {
  final String title;

  const _CreateNameDialog({required this.title});

  @override
  State<_CreateNameDialog> createState() => _CreateNameDialogState();
}

class _CreateNameDialogState extends State<_CreateNameDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final value = _controller.text.trim();

    if (value.isEmpty) return;

    Navigator.pop(context, value);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _submit(),
        decoration: const InputDecoration(
          labelText: "Name",
          hintText: "Enter name",
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        TextButton(onPressed: _submit, child: const Text("Create")),
      ],
    );
  }
}

String _getAvailableName(String requestedName, Iterable<String> existingNames) {
  final normalizedExistingNames = existingNames
      .map((name) => name.trim().toLowerCase())
      .toSet();

  if (!normalizedExistingNames.contains(requestedName.toLowerCase())) {
    return requestedName;
  }

  var number = 2;
  var candidateName = "$requestedName $number";

  while (normalizedExistingNames.contains(candidateName.toLowerCase())) {
    number++;
    candidateName = "$requestedName $number";
  }

  return candidateName;
}

String _getCreateTitle(CreateType type) {
  switch (type) {
    case CreateType.workout:
      return "Create Workout";
    case CreateType.weeklyPlan:
      return "Create Weekly Plan";
    case CreateType.workoutCollection:
      return "Create Workout Collection";
  }
}
