import 'package:first_app/models/weekly_plan_ui_model.dart';
import 'package:flutter/material.dart';
import 'package:first_app/Items/Barrel/item_barrel.dart';
import 'package:first_app/models/workout_ui_model.dart';

Widget workoutSlider({
  required bool isDefault,
  required String title,
  required List<WorkoutUiModel> workouts,
  required VoidCallback onCardClosed,
}) {
  final defaultWorkouts = workouts.where((w) => w.isDefault == true).toList();
  final userWorkouts = workouts.where((w) => w.isDefault == false).toList();

  return Box(
    boxColor: color_1,
    edgeSpaceAllBig: true,
    softCorners: true,
    elevation: 6, // 10 yerine daha soft
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // başlık
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text(title, style: textStyleL),
          ),
          const SizedBox(height: 10),
          Divider(height: 1),

          const SizedBox(height: 12),

          SizedBox(
            height: 200,
            child: ListView.separated(
              padding: const EdgeInsets.all(defaultHeight),
              scrollDirection: Axis.horizontal,
              itemCount: isDefault
                  ? defaultWorkouts.length
                  : userWorkouts.length,
              separatorBuilder: (_, _) => const SizedBox(width: defaultHeight),
              itemBuilder: (context, i) {
                return SizedBox(
                  width: 220, // kart genişliği sabit -> slider hissi
                  child: WorkoutCard(
                    workout: isDefault ? defaultWorkouts[i] : userWorkouts[i],
                    onCardClosed: onCardClosed,
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),
        ],
      ),
    ),
  );
}

Widget planSlider({
  required bool isDefault,
  required String title,
  required List<WeeklyPlanUiModel> plans,
  required VoidCallback onCardClosed,
}) {
  final defaultPlans = plans.where((p) => p.isDefault == true).toList();
  final userPlans = plans.where((p) => p.isDefault == false).toList();

  return Box(
    boxColor: color_1,
    edgeSpaceAllBig: true,
    softCorners: true,
    elevation: 6, // 10 yerine daha soft
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // başlık
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text(title, style: textStyleL),
          ),
          const SizedBox(height: 10),
          Divider(height: 1),

          const SizedBox(height: 12),

          SizedBox(
            height: 200,
            child: ListView.separated(
              padding: const EdgeInsets.all(defaultHeight),
              scrollDirection: Axis.horizontal,
              itemCount: isDefault ? defaultPlans.length : userPlans.length,
              separatorBuilder: (_, _) => const SizedBox(width: defaultHeight),
              itemBuilder: (context, i) {
                return SizedBox(
                  width: 220, // kart genişliği sabit -> slider hissi
                  child: PlanCard(
                    weeklyPlan: isDefault ? defaultPlans[i] : userPlans[i],
                    onCardClosed: onCardClosed,
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),
        ],
      ),
    ),
  );
}
