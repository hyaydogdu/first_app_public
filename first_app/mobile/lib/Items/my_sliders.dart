import 'package:flutter/material.dart';
import 'package:first_app/Items/Barrel/item_barrel.dart';
import 'package:first_app/models/workout_ui_model.dart';

Widget workoutSlider({
  required String title,
  required List<WorkoutUiModel> workouts,
  required VoidCallback onCardClosed,
}) {
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
              itemCount: workouts.length,
              separatorBuilder: (_, _) => const SizedBox(width: defaultHeight),
              itemBuilder: (context, i) {
                return SizedBox(
                  width: 220, // kart genişliği sabit -> slider hissi
                  child: WorkoutCard(
                    workout: workouts[i],
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
