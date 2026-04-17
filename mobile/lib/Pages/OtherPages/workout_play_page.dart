import 'package:first_app/Pages/OtherPages/workout_done_page.dart';
import 'package:flutter/material.dart';
import 'package:first_app/Items/Barrel/item_barrel.dart';
import 'package:first_app/models/workout_ui_model.dart';
import 'dart:async';

class WorkoutPlayPage extends DefaultPage {
  final WorkoutUiModel workout;

  const WorkoutPlayPage({super.key, required this.workout});

  @override
  String get pageName => workout.name;

  @override
  State<WorkoutPlayPage> createState() => _WorkoutPlayPageState();
}

class _WorkoutPlayPageState extends State<WorkoutPlayPage> {
  late WorkoutUiModel currentWorkout;

  late TextEditingController nameController;
  late TextEditingController descriptionController;

  int currentIndex = 0;
  int currentSet = 0;

  Timer? _restTimer;
  bool _isResting = false;
  int _restRemaining = 0;
  int _restTotal = 0;

  int workoutTime = 0;
  Timer? workoutTimer;

  @override
  void initState() {
    super.initState();
    workoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        workoutTime++;
      });
    });
    currentWorkout = widget.workout;
    nameController = TextEditingController(text: currentWorkout.name);
    descriptionController = TextEditingController(
      text: currentWorkout.description ?? "",
    );
  }

  @override
  void dispose() {
    _restTimer?.cancel();
    workoutTimer?.cancel();
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  int _getRestSecondsForCurrentSet() {
    final exercises = widget.workout.workoutExercises;
    if (exercises.isEmpty) return 0;

    final sets = exercises[currentIndex].setList;
    if (sets.isEmpty) return 0;

    final set = sets[currentSet];

    // 1) Eğer modelinde varsa:
    return set.restSeconds;

    // 2) Şimdilik sabit:
    // return 90;
  }

  void _startRest(int seconds) {
    _restTimer?.cancel();

    setState(() {
      _isResting = true;
      _restTotal = seconds <= 0 ? 1 : seconds;
      _restRemaining = seconds;
    });

    if (seconds <= 0) {
      _finishRestAndAdvance();
      return;
    }

    _restTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;

      setState(() {
        _restRemaining--;
      });

      if (_restRemaining <= 0) {
        t.cancel();
        _finishRestAndAdvance();
      }
    });
  }

  void _finishRestAndAdvance() {
    _restTimer?.cancel();
    _restTimer = null;

    setState(() {
      _isResting = false;
      _restRemaining = 0;
    });

    _advanceSetOrExercise(); // rest bitti -> ilerle
  }

  void _skipRest() {
    _finishRestAndAdvance();
  }

  void _addRestSeconds(int extra) {
    if (!_isResting) return;
    setState(() {
      _restRemaining += extra;
      if (_restRemaining + extra > _restTotal) {
        _restTotal += extra;
      }
    });
  }

  void _decreaseRestSeconds(int extra) {
    if (!_isResting) return;
    setState(() {
      _restRemaining -= extra;
    });
  }

  void _advanceSetOrExercise() {
    final exercises = widget.workout.workoutExercises;
    if (exercises.isEmpty) return;

    final sets = exercises[currentIndex].setList;
    if (sets.isEmpty) return;

    setState(() {
      final isLastSet = currentSet >= sets.length - 1;

      if (!isLastSet) {
        currentSet++;
        return;
      }

      final isLastExercise = currentIndex >= exercises.length - 1;
      if (!isLastExercise) {
        currentIndex++;
        currentSet = 0;
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => WorkoutDonePage(
            workout: currentWorkout,
            workoutTime: workoutTime,
          ),
        ),
      );
    });
  }

  /// Kullanıcı seti bitirdiğinde çağır:
  void _completeSetAndStartRest() {
    if (_isResting) return; // rest sırasında tekrar tıklanmasın

    final restSeconds = _getRestSecondsForCurrentSet();
    _startRest(restSeconds);
  }

  @override
  Widget build(BuildContext context) {
    final exercises = widget.workout.workoutExercises;

    if (exercises.isEmpty) {
      return Scaffold(
        backgroundColor: color_1,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: color_2,
          elevation: 0,
          title: Text(widget.workout.name.toUpperCase(), style: textStyleM),
          centerTitle: true,
          leading: Center(
            child: BarIconButtons(onPressed: () => Navigator.pop(context)),
          ),
        ),
        body: const Center(child: Text("No exercises found.")),
      );
    }

    final currentExercise = exercises[currentIndex];
    final sets = currentExercise.setList;

    return Scaffold(
      backgroundColor: color_1,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: color_1,
        elevation: 0,
        title: Text(widget.workout.name.toUpperCase(), style: textStyleM),
        centerTitle: true,
        leading: Center(
          child: BarIconButtons(onPressed: () => Navigator.pop(context)),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 320),
              child: Column(
                children: [
                  Box(
                    boxColor: color_2,
                    softCorners: true,
                    edgeSpaceAllBig: true,
                    child: Column(
                      children: [
                        Box(
                          boxColor: accentColor,
                          edgeSpaceAllBig: true,
                          softCorners: true,
                          child: AppVideoPlayer(url: currentExercise.videoUrl),
                        ),
                        Column(
                          children: _isResting
                              ? [
                                  Text(
                                    currentExercise.exerciseName.toUpperCase(),
                                    style: textStyleL,
                                  ),

                                  Box(
                                    boxColor: Colors.transparent,
                                    edgeSpaceAllSmall: true,
                                    edgeSpaceHorizontal: true,
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: MyProgressBar(
                                        value: (currentSet + 1) / sets.length,
                                        height: 20,
                                        progressColor: accentColor,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "Sets Completed: ${currentSet + 1}/${sets.length}",
                                    style: textStyleS,
                                  ),
                                  const SizedBox(height: defaultHeight),
                                  Text("REST", style: textStyleL),
                                  const SizedBox(height: defaultHeight),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MyTextButton(
                                        text: "-15s",
                                        onPressed: () =>
                                            _decreaseRestSeconds(15),
                                      ),
                                      SizedBox(width: defaultHeight),
                                      RestCirclePro(
                                        restTotal: _restTotal,
                                        restRemaining: _restRemaining,
                                        backgroundColor: color_1,
                                        foregroundColor: accentColor,
                                        timeStyle: textStyleL,
                                        labelStyle: textStyleS,
                                        size: 120,
                                      ),
                                      SizedBox(width: defaultHeight),

                                      MyTextButton(
                                        text: "+15s",
                                        onPressed: () => _addRestSeconds(15),
                                      ),
                                    ],
                                  ),
                                ]
                              : (sets.isNotEmpty
                                    ? [
                                        Text(
                                          currentExercise.exerciseName
                                              .toUpperCase(),
                                          style: textStyleL,
                                        ),
                                        Box(
                                          boxColor: Colors.transparent,
                                          edgeSpaceAllSmall: true,
                                          edgeSpaceHorizontal: true,
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: MyProgressBar(
                                              value: (currentSet) / sets.length,
                                              height: 20,
                                              progressColor: accentColor,
                                            ),
                                          ),
                                        ),

                                        Text(
                                          "Sets Completed: $currentSet/${sets.length}",
                                          style: textStyleS,
                                        ),
                                        SizedBox(height: defaultHeight),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: defaultHeight / 2),
                                            Text(
                                              "Rep: ${sets[currentSet].reps}",
                                              style: textStyleM,
                                            ),
                                            Text(
                                              "Weight: ${formatWeight(sets[currentSet].weightKg)} KG",
                                              style: textStyleM,
                                            ),
                                            SizedBox(height: defaultHeight / 2),
                                          ],
                                        ),
                                      ]
                                    : [
                                        Text(
                                          "No sets for this exercise",
                                          style: textStyleM,
                                        ),
                                      ]),
                        ),
                        SizedBox(height: defaultHeight),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned.fill(
            child: _BottomNextExercisesSheet(
              workout: widget.workout,
              curIndex: currentIndex,
              onComplete: !_isResting ? _completeSetAndStartRest : _skipRest,
              isResting: _isResting,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNextExercisesSheet extends StatelessWidget {
  final WorkoutUiModel workout;
  final VoidCallback onComplete;
  final int curIndex;
  final bool isResting;

  const _BottomNextExercisesSheet({
    required this.workout,
    required this.curIndex,
    required this.onComplete,
    required this.isResting,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: true,
      initialChildSize: 0.2,
      minChildSize: 0.2,
      maxChildSize: 1,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: color_2,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.only(bottom: 16),
            children: [
              const SizedBox(height: defaultHeight / 2),
              Center(
                child: Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: color_1,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),

              // Current Exercise Card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    // Complete exercise üst tarafı
                    Row(
                      children: [
                        workoutImage(
                          workout.workoutExercises[curIndex].exerciseImageUrl!,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Next Exercise", style: textStyleS),
                              Text(
                                curIndex + 1 < workout.workoutExercises.length
                                    ? workout
                                          .workoutExercises[curIndex + 1]
                                          .exerciseName
                                          .toUpperCase()
                                    : "FINISHING",
                                style: textStyleM,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    //Complete Exercise Butonu
                    SizedBox(
                      width: double.infinity,
                      child: MyTextButton(
                        text: !isResting ? "Complete set" : "skip Rest",
                        onPressed: onComplete,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: defaultHeight),
              // Next Exercises Header
              Box(
                boxColor: color_1,
                edgeSpaceAllSmall: true,
                softCorners: true,
                child: SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: Text("Next Exercises", style: textStyleS),
                  ),
                ),
              ),

              // Exercises List
              ...List.generate(workout.workoutExercises.length, (index) {
                final we = workout.workoutExercises[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: index == curIndex ? color_1 : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(25),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text("${index + 1})", style: textStyleM),
                        ),
                        workoutImage(we.exerciseImageUrl!),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            we.exerciseName.toUpperCase(),
                            style: textStyleM,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
