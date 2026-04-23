import 'package:first_app/models/exercise_ui_model.dart';
import 'package:first_app/models/workout_set_ui_model.dart';
import 'package:flutter/material.dart';
import 'package:first_app/models/workout_exercise_ui_model.dart';
import 'package:first_app/Items/Barrel/item_barrel.dart';
import 'package:first_app/Services/api_config.dart';

class ViewWorkoutExerciseCard extends StatelessWidget {
  final WorkoutExerciseUiModel we;
  final Map<int, bool> expandedMap;
  final int stableKey;
  final VoidCallback refreshPage;

  const ViewWorkoutExerciseCard({
    super.key,
    required this.we,
    required this.expandedMap,
    required this.stableKey,
    required this.refreshPage,
  });

  @override
  Widget build(BuildContext context) {
    return WorkoutExerciseCard(
      we: we,
      expandedMap: expandedMap,
      stableKey: stableKey,
      refreshPage: refreshPage,
      expandedBuilder: (context, we) {
        return Column(
          children: we.setList.asMap().entries.expand((entry) {
            final i = entry.key;
            final set = entry.value;
            return [
              const SizedBox(height: defaultHeight),
              Box(
                boxColor: color_1,
                softCorners: true,
                edgeSpaceHorizontal: true,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Row(
                    children: [
                      const Expanded(flex: 1, child: SizedBox()),
                      Expanded(
                        flex: 4,
                        child: Text("Set: ${i + 1}", style: textStyleS),
                      ),
                      Expanded(
                        flex: 4,
                        child: Text("${set.reps} rep", style: textStyleS),
                      ),
                      Expanded(
                        flex: 4,
                        child: Text(
                          "${formatWeight(set.weightKg)} KG",
                          style: textStyleS,
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Text(
                          "${set.restSeconds} sec",
                          style: textStyleS,
                        ),
                      ),
                      const Expanded(
                        flex: 2,
                        child: SizedBox(height: 24, width: 24),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(),
            ];
          }).toList(),
        );
      },
    );
  }
}

class EditWorkoutExerciseCard extends StatelessWidget {
  final WorkoutExerciseUiModel we;
  final int listIndex;
  final int stableKey;
  final VoidCallback onDeleteExercise;
  final VoidCallback onAddSet;
  final Map<int, bool> expandedMap;
  final VoidCallback refreshPage;

  final void Function(int setIndex, WorkoutSetUiModel updatedSet) onUpdateSet;
  final void Function(int setIndex) onDeleteSet;

  const EditWorkoutExerciseCard({
    super.key,
    required this.we,
    required this.listIndex,
    required this.stableKey,
    required this.onDeleteExercise,
    required this.onAddSet,
    required this.onUpdateSet,
    required this.onDeleteSet,
    required this.expandedMap,
    required this.refreshPage,
  });

  Future<WorkoutSetUiModel?> _editSetDialog(
    BuildContext context,
    WorkoutSetUiModel set,
  ) async {
    final kgCtrl = TextEditingController(text: set.weightKg.toString());
    final restCtrl = TextEditingController(text: set.restSeconds.toString());
    final repCtrl = TextEditingController(text: set.reps.toString());

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Set"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: repCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Rep"),
            ),
            TextField(
              controller: kgCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "KG"),
            ),
            TextField(
              controller: restCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Rest (sec)"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Save"),
          ),
        ],
      ),
    );

    if (ok != true) return null;

    final kg = double.tryParse(kgCtrl.text) ?? set.weightKg;
    final rest = int.tryParse(restCtrl.text) ?? set.restSeconds;
    final rep = int.tryParse(repCtrl.text) ?? set.reps;

    return set.copyWith(weightKg: kg, restSeconds: rest, reps: rep);
  }

  @override
  Widget build(BuildContext context) {
    return WorkoutExerciseCard(
      we: we,
      headerTrailing: IconButtonS(onPressed: onDeleteExercise),
      leading: ReorderableDragStartListener(
        index: listIndex,
        child: const Icon(Icons.drag_handle),
      ),
      expandedMap: expandedMap,
      stableKey: stableKey,
      refreshPage: refreshPage,
      expandedBuilder: (context, we) {
        return Column(
          children: [
            ...we.setList.asMap().entries.expand((entry) {
              final i = entry.key;
              final set = entry.value;
              return [
                SizedBox(height: defaultHeight),
                InkWell(
                  onTap: () async {
                    final updated = await _editSetDialog(context, set);
                    if (updated != null) {
                      onUpdateSet(i, updated);
                    }
                  },
                  child: Box(
                    boxColor: Colors.transparent,
                    softCorners: true,
                    edgeSpaceHorizontal: true,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Row(
                        children: [
                          const Expanded(flex: 1, child: SizedBox()),
                          Expanded(
                            flex: 4,
                            child: Text("Set: ${i + 1}", style: textStyleS),
                          ),
                          Expanded(
                            flex: 4,
                            child: Text("${set.reps} rep", style: textStyleS),
                          ),
                          Expanded(
                            flex: 4,
                            child: Text(
                              "${formatWeight(set.weightKg)} KG",
                              style: textStyleS,
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Text(
                              "${set.restSeconds} sec",
                              style: textStyleS,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: IconButtonS(onPressed: () => onDeleteSet(i)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Divider(height: 1),
              ];
            }),
            SizedBox(height: defaultHeight / 2),
            SizedBox(
              width: double.infinity,
              child: MyTextButton(
                text: "Add Set",
                bgColor: color_2,
                onPressed: onAddSet,
              ),
            ),
          ],
        );
      },
    );
  }
}

class WorkoutExerciseCard extends StatefulWidget {
  final WorkoutExerciseUiModel we;
  final Map<int, bool> expandedMap;
  final int stableKey;
  final VoidCallback refreshPage;

  final Widget? headerTrailing;
  final Widget? leading;

  final Widget Function(BuildContext context, WorkoutExerciseUiModel we)
  expandedBuilder;

  const WorkoutExerciseCard({
    super.key,
    required this.we,
    required this.expandedBuilder,
    this.headerTrailing,
    required this.expandedMap,
    required this.stableKey,
    required this.refreshPage,
    this.leading,
  });

  @override
  State<WorkoutExerciseCard> createState() => _WorkoutExerciseCardState();
}

class _WorkoutExerciseCardState extends State<WorkoutExerciseCard>
    with TickerProviderStateMixin {
  bool get isExpanded => widget.expandedMap[widget.stableKey] ?? false;

  @override
  Widget build(BuildContext context) {
    return Box(
      boxColor: color_1,
      edgeSpaceAllBig: true,
      softCorners: true,
      child: Column(
        children: [
          SizedBox(height: defaultHeight / 2),
          Row(
            children: [
              workoutImage(widget.we.exerciseImageUrl!),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.we.exerciseName,
                  style: textStyleS.copyWith(fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: Colors.black.withAlpha(10),
                ),
                child: Text(
                  "Sets: ${widget.we.setList.length}",
                  style: textStyleS,
                ),
              ),
              if (widget.headerTrailing != null) ...[widget.headerTrailing!],
              if (widget.leading != null) ...[widget.leading!],
            ],
          ),
          InkWell(
            onTap: () {
              widget.expandedMap[widget.stableKey] = !isExpanded;
              setState(() {});
              widget.refreshPage();
            },
            child: Box(
              boxColor: color_1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(isExpanded ? "Hide Sets" : "Sets", style: textStyleS),
                  const SizedBox(width: 8),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: isExpanded
                ? Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Column(
                      children: [
                        Box(
                          boxColor: color_2,
                          softCorners: true,
                          edgeSpaceHorizontal: true,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(12, 8, 0, 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Expanded(flex: 1, child: SizedBox()),
                                Expanded(
                                  flex: 4,
                                  child: Text("Set", style: textStyleS),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Text("Reps", style: textStyleS),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Text("Weight", style: textStyleS),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Text("Rest", style: textStyleS),
                                ),
                                const Expanded(flex: 2, child: SizedBox()),
                              ],
                            ),
                          ),
                        ),
                        widget.expandedBuilder(context, widget.we),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

// 🔥 Exercise Selection sayfası için kullanılan kart
class SelectExerciseCard extends StatelessWidget {
  final ExerciseUiModel exercise;
  const SelectExerciseCard({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context, exercise); // 🔥
      },
      borderRadius: BorderRadius.circular(8),
      child: BorderBox(
        boxColor: color_1,
        edgeSpaceAllSmall: true,
        softCorners: true,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            workoutImage(exercise.imageUrl!),
            SizedBox(width: defaultHeight),
            SizedBox(width: 220, child: Text(exercise.name, style: textStyleS)),
          ],
        ),
      ),
    );
  }
}

Widget workoutImage(String imageUrl) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: Image.network(
      ApiConfig.endpoint(imageUrl),
      height: 56,
      width: 56,
      fit: BoxFit.cover,
    ),
  );
}
