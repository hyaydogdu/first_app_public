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
  final VoidCallback? onAddSet;
  final void Function(int setIndex, WorkoutSetUiModel set)? onTapSet;
  final void Function(int setIndex)? onDeleteSet;

  const _WorkoutSetTable({
    required this.sets,
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
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const _WorkoutSetRow({
    required this.index,
    required this.set,
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
            _setTableText("Set: ${index + 1}"),
            _setTableText("${set.reps} rep"),
            _setTableText("${formatWeight(set.weightKg)} KG"),
            _setTableText("${set.restSeconds} sec"),
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
            _setTableText("Set"),
            _setTableText("Reps"),
            _setTableText("Weight"),
            _setTableText("Rest"),
            const Expanded(flex: 2, child: SizedBox()),
          ],
        ),
      ),
    );
  }
}

Widget _setTableText(String text) {
  return Expanded(flex: 4, child: Text(text, style: textStyleS));
}

Future<WorkoutSetUiModel?> _showEditWorkoutSetDialog(
  BuildContext context,
  WorkoutSetUiModel set,
) async {
  final kgCtrl = TextEditingController(text: set.weightKg.toString());
  final restCtrl = TextEditingController(text: set.restSeconds.toString());
  final repCtrl = TextEditingController(text: set.reps.toString());

  try {
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
  } finally {
    kgCtrl.dispose();
    restCtrl.dispose();
    repCtrl.dispose();
  }
}
