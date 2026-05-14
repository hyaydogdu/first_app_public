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
  final defaultWorkouts = workouts.where((w) => w.isDefault == true).toList()
    ..sort(_sortWorkoutsNewestFirst);
  final userWorkouts = workouts.where((w) => w.isDefault == false).toList()
    ..sort(_sortWorkoutsNewestFirst);
  final sliderWorkouts = isDefault ? defaultWorkouts : userWorkouts;

  return Box(
    boxColor: color_2,
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
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(title, style: textStyleL),
          ),
          const SizedBox(height: 10),

          SizedBox(
            height: 200,
            child: ListView.separated(
              padding: const EdgeInsets.all(defaultHeight),
              scrollDirection: Axis.horizontal,
              itemCount: sliderWorkouts.length,
              separatorBuilder: (_, _) => const SizedBox(width: defaultHeight),
              itemBuilder: (context, i) {
                return SizedBox(
                  key: ValueKey(sliderWorkouts[i].id),
                  width: 220, // kart genişliği sabit -> slider hissi
                  child: WorkoutCard(
                    workout: sliderWorkouts[i],
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
  final defaultPlans = plans.where((p) => p.isDefault == true).toList()
    ..sort(_sortPlansNewestFirst);
  final userPlans = plans.where((p) => p.isDefault == false).toList()
    ..sort(_sortPlansNewestFirst);
  final sliderPlans = isDefault ? defaultPlans : userPlans;

  return Box(
    boxColor: color_2,
    edgeSpaceAllBig: true,
    softCorners: true,
    elevation: 6,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // başlık
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(title, style: textStyleL),
          ),
          const SizedBox(height: 10),
          //Liste
          SizedBox(
            height: 200,
            child: ListView.separated(
              padding: const EdgeInsets.all(defaultHeight),
              scrollDirection: Axis.horizontal,
              itemCount: sliderPlans.length,
              separatorBuilder: (_, _) => const SizedBox(width: defaultHeight),
              itemBuilder: (context, i) {
                return SizedBox(
                  key: ValueKey(sliderPlans[i].id),
                  width: 220, // kart genişliği sabit -> slider hissi
                  child: PlanCard(
                    weeklyPlan: sliderPlans[i],
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

int _sortWorkoutsNewestFirst(WorkoutUiModel a, WorkoutUiModel b) {
  final dateCompare = b.createdAt.compareTo(a.createdAt);
  if (dateCompare != 0) return dateCompare;

  return b.id.compareTo(a.id);
}

int _sortPlansNewestFirst(WeeklyPlanUiModel a, WeeklyPlanUiModel b) {
  final dateCompare = b.createdAt.compareTo(a.createdAt);
  if (dateCompare != 0) return dateCompare;

  return b.id.compareTo(a.id);
}
