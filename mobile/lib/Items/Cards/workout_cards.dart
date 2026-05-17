import 'package:first_app/models/exercise_ui_model.dart';
import 'package:first_app/models/workout_set_ui_model.dart';
import 'package:flutter/material.dart';
import 'package:first_app/models/workout_exercise_ui_model.dart';
import 'package:first_app/Items/Barrel/item_barrel.dart';

class ViewWorkoutExerciseCard extends StatelessWidget {
  final WorkoutExerciseUiModel we;
  final Map<int, bool> expandedMap;
  final int stableKey;

  const ViewWorkoutExerciseCard({
    super.key,
    required this.we,
    required this.expandedMap,
    required this.stableKey,
  });

  @override
  Widget build(BuildContext context) {
    return _WorkoutExerciseCard(
      we: we,
      expandedMap: expandedMap,
      stableKey: stableKey,
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
  });

  @override
  Widget build(BuildContext context) {
    return _WorkoutExerciseCard(
      we: we,
      expandedMap: expandedMap,
      stableKey: stableKey,
      headerActions: [
        IconButton(icon: const Icon(Icons.delete), onPressed: onDeleteExercise),
        ReorderableDragStartListener(
          index: listIndex,
          child: const Icon(Icons.drag_handle),
        ),
      ],
      onTapSet: (i, set) async {
        final updated = await _showEditWorkoutSetDialog(context, set);
        if (updated != null) {
          onUpdateSet(i, updated);
        }
      },
      onDeleteSet: onDeleteSet,
      onAddSet: onAddSet,
    );
  }
}

class _WorkoutExerciseCard extends StatefulWidget {
  final WorkoutExerciseUiModel we;
  final Map<int, bool> expandedMap;
  final int stableKey;

  final List<Widget> headerActions;
  final VoidCallback? onAddSet;
  final void Function(int setIndex, WorkoutSetUiModel set)? onTapSet;
  final void Function(int setIndex)? onDeleteSet;

  const _WorkoutExerciseCard({
    required this.we,
    this.headerActions = const [],
    required this.expandedMap,
    required this.stableKey,
    this.onAddSet,
    this.onTapSet,
    this.onDeleteSet,
  });

  @override
  State<_WorkoutExerciseCard> createState() => _WorkoutExerciseCardState();
}

class _WorkoutExerciseCardState extends State<_WorkoutExerciseCard> {
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
          _WorkoutExerciseHeader(we: widget.we, actions: widget.headerActions),
          _ExpandButton(
            isExpanded: isExpanded,
            onTap: () {
              widget.expandedMap[widget.stableKey] = !isExpanded;
              setState(() {});
            },
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: isExpanded
                ? Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: _WorkoutSetTable(
                      sets: widget.we.setList,
                      exerciseType: widget.we.exerciseType,
                      onTapSet: widget.onTapSet,
                      onDeleteSet: widget.onDeleteSet,
                      onAddSet: widget.onAddSet,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _WorkoutExerciseHeader extends StatelessWidget {
  final WorkoutExerciseUiModel we;
  final List<Widget> actions;

  const _WorkoutExerciseHeader({required this.we, required this.actions});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        imageDisplayer(we.exerciseImageUrl!),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            we.exerciseName,
            style: textStyleS.copyWith(fontWeight: FontWeight.w600),
            overflow: TextOverflow.ellipsis,
          ),
        ),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: Colors.black.withAlpha(10),
          ),
          child: Text("Sets: ${we.setList.length}", style: textStyleS),
        ),
        ...actions,
      ],
    );
  }
}

class _ExpandButton extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onTap;

  const _ExpandButton({required this.isExpanded, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Box(
        boxColor: color_1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(isExpanded ? "Hide Sets" : "Sets", style: textStyleS),
            const SizedBox(width: 8),
            Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkoutSetTable extends StatelessWidget {
  final List<WorkoutSetUiModel> sets;
  final ExerciseType exerciseType;
  final VoidCallback? onAddSet;
  final void Function(int setIndex, WorkoutSetUiModel set)? onTapSet;
  final void Function(int setIndex)? onDeleteSet;

  const _WorkoutSetTable({
    required this.sets,
    required this.exerciseType,
    this.onAddSet,
    this.onTapSet,
    this.onDeleteSet,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _WorkoutSetHeader(),
        ...sets.asMap().entries.expand((entry) {
          final i = entry.key;
          final set = entry.value;

          return [
            SizedBox(height: defaultHeight),
            _WorkoutSetRow(
              index: i,
              set: set,
              exerciseType: exerciseType,
              onDelete: onDeleteSet == null ? null : () => onDeleteSet!(i),
              onTap: onTapSet == null ? null : () => onTapSet!(i, set),
            ),
            const Divider(),
          ];
        }),
        if (onAddSet != null) ...[
          SizedBox(height: defaultHeight / 2),
          SizedBox(
            width: double.infinity,
            child: MyTextButton(
              text: "Add Set",
              color: color_2,
              onPressed: onAddSet!,
            ),
          ),
        ],
      ],
    );
  }
}

class _WorkoutSetRow extends StatelessWidget {
  final int index;
  final WorkoutSetUiModel set;
  final ExerciseType exerciseType;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const _WorkoutSetRow({
    required this.index,
    required this.set,
    required this.exerciseType,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final row = Box(
      boxColor: color_1,
      softCorners: true,
      edgeSpaceHorizontal: true,
      child: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Row(
          children: [
            const Expanded(flex: 1, child: SizedBox()),
            _setTableText("Set: ${index + 1}", flex: 3),
            _setTableText(
              set.reps == 0 ? "Failure" : "${set.reps} rep",
              flex: 4,
            ),
            _setTableText(_weightText(set, exerciseType), flex: 6),
            _setTableText("${set.restSeconds} sec", flex: 4),
            Expanded(
              flex: 2,
              child: onDelete == null
                  ? const SizedBox(height: 24, width: 24)
                  : IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: onDelete,
                    ),
            ),
          ],
        ),
      ),
    );

    if (onTap == null) return row;

    return InkWell(onTap: onTap, child: row);
  }
}

class _WorkoutSetHeader extends StatelessWidget {
  const _WorkoutSetHeader();

  @override
  Widget build(BuildContext context) {
    return Box(
      boxColor: color_2,
      softCorners: true,
      edgeSpaceHorizontal: true,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 0, 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Expanded(flex: 1, child: SizedBox()),
            _setTableText("Set", flex: 3),
            _setTableText("Reps", flex: 4),
            _setTableText("Weight", flex: 6),
            _setTableText("Rest", flex: 4),
            const Expanded(flex: 2, child: SizedBox()),
          ],
        ),
      ),
    );
  }
}

Widget _setTableText(String text, {int flex = 4}) {
  return Expanded(
    flex: flex,
    child: FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.center,
      child: Text(text, style: textStyleS),
    ),
  );
}

String _weightText(WorkoutSetUiModel set, ExerciseType exerciseType) {
  if (set.weightKg == 0) {
    return exerciseType == ExerciseType.bodyweightBased ? "Bodyweight" : "-";
  }

  return "${formatWeight(set.weightKg)} KG";
}

Future<WorkoutSetUiModel?> _showEditWorkoutSetDialog(
  BuildContext context,
  WorkoutSetUiModel set,
) async {
  return showDialog<WorkoutSetUiModel?>(
    context: context,
    builder: (_) => _EditWorkoutSetDialog(set: set),
  );
}

class _EditWorkoutSetDialog extends StatefulWidget {
  final WorkoutSetUiModel set;

  const _EditWorkoutSetDialog({required this.set});

  @override
  State<_EditWorkoutSetDialog> createState() => _EditWorkoutSetDialogState();
}

class _EditWorkoutSetDialogState extends State<_EditWorkoutSetDialog> {
  late String kgText;
  late String restText;
  late String repText;

  @override
  void initState() {
    super.initState();
    kgText = widget.set.weightKg.toString();
    restText = widget.set.restSeconds.toString();
    repText = widget.set.reps.toString();
  }

  void _save() {
    final kg = double.tryParse(kgText) ?? widget.set.weightKg;
    final rest = int.tryParse(restText) ?? widget.set.restSeconds;
    final rep = int.tryParse(repText) ?? widget.set.reps;

    Navigator.pop(
      context,
      widget.set.copyWith(weightKg: kg, restSeconds: rest, reps: rep),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Set"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            initialValue: repText,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "Rep"),
            onChanged: (value) => repText = value,
          ),
          TextFormField(
            initialValue: kgText,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "KG"),
            onChanged: (value) => kgText = value,
          ),
          TextFormField(
            initialValue: restText,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "Rest (sec)"),
            onChanged: (value) => restText = value,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        TextButton(onPressed: _save, child: const Text("Save")),
      ],
    );
  }
}
