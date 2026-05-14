import 'package:first_app/Pages/Barrel/page_barrel.dart';
import 'package:first_app/Services/workout_api.dart';
import 'package:first_app/models/exercise_ui_model.dart';
import 'package:first_app/models/workout_exercise_ui_model.dart';
import 'package:first_app/models/workout_set_ui_model.dart';
import 'package:flutter/material.dart';
import 'package:first_app/Items/Barrel/item_barrel.dart';
import 'package:first_app/models/workout_ui_model.dart';

class WorkoutViewPage extends DefaultPage {
  final WorkoutUiModel workout;

  const WorkoutViewPage({super.key, required this.workout});

  @override
  String get pageName => workout.name;

  @override
  State<WorkoutViewPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutViewPage> {
  final Map<int, bool> expandedMap = {};
  bool isEditing = false;
  bool isLoadingWorkout = false;
  late WorkoutUiModel currentWorkout;
  WorkoutUiModel? editingWorkout;

  late TextEditingController nameController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    currentWorkout = widget.workout;
    nameController = TextEditingController(text: currentWorkout.name);
    descriptionController = TextEditingController(
      text: currentWorkout.description ?? "",
    );
    _loadWorkoutDetails();
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadWorkoutDetails() async {
    setState(() {
      isLoadingWorkout = true;
    });

    try {
      final workout = await WorkoutApi.getWorkoutById(widget.workout.id);
      if (!mounted) return;

      setState(() {
        if (!isEditing) {
          currentWorkout = workout;
          nameController.text = workout.name;
          descriptionController.text = workout.description ?? "";
        }
      });
    } catch (e) {
      debugPrint("Failed to load workout details: $e");
    } finally {
      if (mounted) {
        setState(() {
          isLoadingWorkout = false;
        });
      }
    }
  }

  Future<void> _save() async {
    final newName = nameController.text.trim();
    final newDesc = descriptionController.text.trim();
    final workoutToSave = editingWorkout ?? currentWorkout;

    if (newName.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Workout name boş olamaz")));
      return;
    }

    try {
      for (int i = 0; i < workoutToSave.workoutExercises.length; i++) {
        workoutToSave.workoutExercises[i] = workoutToSave.workoutExercises[i]
            .copyWith(orderIndex: i);
      }

      await WorkoutApi.updateWorkoutHeader(
        id: workoutToSave.id,
        name: newName,
        description: newDesc.isEmpty ? null : newDesc,
      );

      await WorkoutApi.updateWorkoutExercises(
        workoutId: workoutToSave.id,
        exercises: workoutToSave.workoutExercises,
      );

      if (!mounted) return;

      setState(() {
        currentWorkout = workoutToSave.copyWith(
          name: newName,
          description: newDesc.isEmpty ? null : newDesc,
          workoutExercises: workoutToSave.workoutExercises,
        );
        editingWorkout = null;
        isEditing = false;
      });
    } catch (e) {
      debugPrint("❌ SAVE FAILED: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Save failed: $e")));
    }
  }

  void _startEditing() {
    setState(() {
      editingWorkout = _copyWorkout(currentWorkout);
      nameController.text = currentWorkout.name;
      descriptionController.text = currentWorkout.description ?? "";
      isEditing = true;
    });
  }

  void _deleteWorkout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Confirm Deletion"),
        content: const Text("Are you sure you want to delete this workout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (!mounted) return;

    if (confirm != true) return;

    try {
      await WorkoutApi.deleteWorkout(widget.workout.id);

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Delete failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color_1,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: color_1,
        elevation: 0,
        title: Text("WORKOUT", style: textStyleM),
        centerTitle: true,
        leading: Center(
          child: BarIconButton(onPressed: () => Navigator.pop(context)),
        ),
        actions: [
          if (!currentWorkout.isDefault) ...[
            SizedBox(
              width: kToolbarHeight,
              height: kToolbarHeight,
              child: BarIconButton(
                buttonIcon: Icon(
                  isEditing ? Icons.check_rounded : Icons.edit_note_sharp,
                ),
                onPressed: () async {
                  if (isEditing) {
                    await _save();
                  } else {
                    _startEditing();
                  }
                },
              ),
            ),
            SizedBox(
              width: kToolbarHeight,
              height: kToolbarHeight,
              child: BarIconButton(
                buttonIcon: Icon(Icons.delete_rounded),
                onPressed: () async {
                  _deleteWorkout();
                },
              ),
            ),
          ],
        ],
      ),
      body: isEditing
          ? _EditMode(
              nameController: nameController,
              descriptionController: descriptionController,
              workout: editingWorkout!,
              expandedMap: expandedMap,
            )
          : _ViewMode(workout: currentWorkout, expandedMap: expandedMap),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: color_2,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(75),
              blurRadius: 5,
              spreadRadius: 2,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            defaultHeight,
            defaultHeight / 4,
            defaultHeight,
            defaultHeight * 3 / 4,
          ),
          child: MyTextButton(
            text: isLoadingWorkout ? "Loading..." : "Go to Workout",
            color: isLoadingWorkout ? Colors.grey.shade400 : null,
            onPressed: () async {
              if (isLoadingWorkout) return;
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WorkoutPlayPage(workout: currentWorkout),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

WorkoutUiModel _copyWorkout(WorkoutUiModel workout) {
  return workout.copyWith(
    workoutExercises: workout.workoutExercises
        .map(_copyWorkoutExercise)
        .toList(),
  );
}

WorkoutExerciseUiModel _copyWorkoutExercise(WorkoutExerciseUiModel exercise) {
  return exercise.copyWith(
    setList: exercise.setList.map((set) => set.copyWith()).toList(),
  );
}

class _ViewMode extends StatelessWidget {
  final WorkoutUiModel workout;
  final Map<int, bool> expandedMap;

  const _ViewMode({required this.workout, required this.expandedMap});

  @override
  Widget build(BuildContext context) {
    final sortedExercises = [...workout.workoutExercises]
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

    return Column(
      children: [
        Flexible(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: defaultHeight * 2,
                child: Text(
                  workout.name.toUpperCase(),
                  style: textStyleM,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: defaultHeight * 2,
                child: Text(
                  workout.description?.toLowerCase() ?? "",
                  style: textStyleS,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        const Divider(),
        Flexible(
          flex: 5,
          child: ListView.builder(
            padding: EdgeInsets.only(bottom: defaultHeight * 5),
            itemCount: sortedExercises.length,
            itemBuilder: (context, index) {
              final we = sortedExercises[index];
              final stableKey = we.exerciseId * 100000 + we.orderIndex;
              return ViewWorkoutExerciseCard(
                we: we,
                expandedMap: expandedMap,
                stableKey: stableKey,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _EditMode extends StatefulWidget {
  final WorkoutUiModel workout;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final Map<int, bool> expandedMap;

  const _EditMode({
    required this.workout,
    required this.nameController,
    required this.descriptionController,
    required this.expandedMap,
  });

  @override
  State<_EditMode> createState() => _EditModeState();
}

class _EditModeState extends State<_EditMode> {
  Future<void> addExercise(BuildContext context) async {
    final selected = await Navigator.push<ExerciseUiModel>(
      context,
      MaterialPageRoute(builder: (_) => const ExerciseSelectionPage()),
    );

    if (selected == null) return;

    setState(() {
      widget.workout.workoutExercises.add(
        WorkoutExerciseUiModel(
          id: 0,
          exerciseId: selected.id,
          exerciseName: selected.name,
          exerciseImageUrl: selected.imageUrl,
          videoUrl: selected.videoUrl,
          orderIndex: widget.workout.workoutExercises.length,
          setList: [
            WorkoutSetUiModel(
              setIndex: 0,
              weightKg: 0,
              restSeconds: 30,
              reps: 0,
            ),
          ],
        ),
      );
    });
  }

  int _stableExerciseKey(WorkoutExerciseUiModel we) {
    return we.exerciseId * 100000 + we.orderIndex;
  }

  void deleteExercise(WorkoutExerciseUiModel we) {
    setState(() {
      widget.workout.workoutExercises.removeWhere((e) => e == we);
      for (int i = 0; i < widget.workout.workoutExercises.length; i++) {
        widget.workout.workoutExercises[i] = widget.workout.workoutExercises[i]
            .copyWith(orderIndex: i);
      }
    });
  }

  void addSetToExercise(WorkoutExerciseUiModel we) {
    setState(() {
      final newSet = WorkoutSetUiModel(
        weightKg: 0,
        restSeconds: 60,
        reps: 0,
        setIndex: we.setList.length,
      );

      we.setList.add(newSet);
    });
  }

  @override
  Widget build(BuildContext context) {
    final sortedExercises = [...widget.workout.workoutExercises]
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

    return Column(
      children: [
        Flexible(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: widget.nameController,
                  style: textStyleM,
                  textAlign: TextAlign.center,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(
                        strokeAlign: BorderSide.strokeAlignCenter,
                      ),
                    ),
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              SizedBox(height: defaultHeight / 2),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: widget.descriptionController,
                  style: textStyleS,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(),
                    ),
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(),
        Flexible(
          flex: 5,
          child: Stack(
            children: [
              ReorderableListView.builder(
                padding: EdgeInsets.only(
                  bottom: defaultHeight * 6,
                ), // buton için boşluk
                itemCount: sortedExercises.length,
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) newIndex--;

                    final list = [...widget.workout.workoutExercises]
                      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

                    final moved = list.removeAt(oldIndex);
                    list.insert(newIndex, moved);

                    for (int i = 0; i < list.length; i++) {
                      list[i] = list[i].copyWith(orderIndex: i);
                    }

                    widget.workout.workoutExercises
                      ..clear()
                      ..addAll(list);
                  });
                },
                itemBuilder: (context, index) {
                  final we = sortedExercises[index];

                  return EditWorkoutExerciseCard(
                    key: ValueKey(_stableExerciseKey(we)),
                    listIndex: index,
                    we: we,
                    expandedMap: widget.expandedMap,
                    stableKey: _stableExerciseKey(we),
                    onDeleteExercise: () => deleteExercise(we),
                    onAddSet: () => addSetToExercise(we),
                    onUpdateSet: (setIndex, updatedSet) {
                      setState(() {
                        final exIndex = widget.workout.workoutExercises
                            .indexWhere((e) => e.orderIndex == we.orderIndex);
                        if (exIndex == -1) return;
                        final ex = widget.workout.workoutExercises[exIndex];

                        final newSetList = [...ex.setList];
                        newSetList[setIndex] = updatedSet;

                        widget.workout.workoutExercises[exIndex] = ex.copyWith(
                          setList: newSetList,
                        );
                      });
                    },
                    onDeleteSet: (setIndex) {
                      setState(() {
                        final exIndex = widget.workout.workoutExercises
                            .indexWhere((e) => e.orderIndex == we.orderIndex);
                        if (exIndex == -1) return;
                        final ex = widget.workout.workoutExercises[exIndex];

                        final newSetList = [...ex.setList]..removeAt(setIndex);

                        final fixed = [
                          for (int i = 0; i < newSetList.length; i++)
                            newSetList[i].copyWith(setIndex: i),
                        ];

                        widget.workout.workoutExercises[exIndex] = ex.copyWith(
                          setList: fixed,
                        );
                      });
                    },
                  );
                },
              ),

              /// FLOATING ADD EXERCISE BUTTON
              Positioned(
                left: defaultHeight,
                right: defaultHeight,
                bottom: defaultHeight / 2,
                child: MyTextButton(
                  text: "Add Exercise",
                  color: color_2,
                  strokeColor: Colors.black,
                  onPressed: () => addExercise(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
