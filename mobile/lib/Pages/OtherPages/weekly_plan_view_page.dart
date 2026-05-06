import 'package:first_app/Items/Barrel/item_barrel.dart';
import 'package:first_app/models/weekly_plan_ui_model.dart';
import 'package:flutter/material.dart';

class WeeklyPlanViewPage extends DefaultPage {
  final WeeklyPlanUiModel weeklyPlan;
  const WeeklyPlanViewPage({super.key, required this.weeklyPlan});

  @override
  String get pageName => "Weekly Plan View";

  @override
  State<WeeklyPlanViewPage> createState() => _WeeklyplanViewPageState();
}

class _WeeklyplanViewPageState extends State<WeeklyPlanViewPage> {
  bool isEditing = false;
  late WeeklyPlanUiModel currentWeeklyPlan;

  @override
  void initState() {
    super.initState();
    currentWeeklyPlan = widget.weeklyPlan;
  }

  Future<void> _save() async {
    // Kaydetme işlemi burada yapılır (örneğin, veritabanına kaydetme)
    // Bu örnekte sadece düzenleme modunu kapatıyoruz
    setState(() {
      isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color_1,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Weekly Plan", style: textStyleM),
        backgroundColor: color_1,
        elevation: 0,
        leading: BarIconButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          if (!currentWeeklyPlan.isDefault)
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
                    setState(() {
                      isEditing = true;
                    });
                  }
                },
              ),
            ),
        ],
      ),
      body: isEditing
          ? _EditMode(weeklyPlan: currentWeeklyPlan)
          : _ViewMode(weeklyPlan: currentWeeklyPlan),
    );
  }
}

class _ViewMode extends StatelessWidget {
  final WeeklyPlanUiModel weeklyPlan;
  const _ViewMode({required this.weeklyPlan});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text(
          textCase(weeklyPlan.name, TextCaseMode.title),
          textAlign: TextAlign.center,
          style: textStyleXL,
        ),
        WeekDayCard(day: "Monday", weeklyPlan: weeklyPlan),
        WeekDayCard(day: "Tuesday", weeklyPlan: weeklyPlan),
        WeekDayCard(day: "Wednesday", weeklyPlan: weeklyPlan),
        WeekDayCard(day: "Thursday", weeklyPlan: weeklyPlan),
        WeekDayCard(day: "Friday", weeklyPlan: weeklyPlan),
        WeekDayCard(day: "Saturday", weeklyPlan: weeklyPlan),
        WeekDayCard(day: "Sunday", weeklyPlan: weeklyPlan),
      ],
    );
  }
}

class _EditMode extends StatelessWidget {
  final WeeklyPlanUiModel weeklyPlan;
  const _EditMode({required this.weeklyPlan});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text(
          textCase(weeklyPlan.name, TextCaseMode.title),
          textAlign: TextAlign.center,
          style: textStyleXL,
        ),
        WeekDayCardEdit(day: "Monday", weeklyPlan: weeklyPlan),
        WeekDayCardEdit(day: "Tuesday", weeklyPlan: weeklyPlan),
        WeekDayCardEdit(day: "Wednesday", weeklyPlan: weeklyPlan),
        WeekDayCardEdit(day: "Thursday", weeklyPlan: weeklyPlan),
        WeekDayCardEdit(day: "Friday", weeklyPlan: weeklyPlan),
        WeekDayCardEdit(day: "Saturday", weeklyPlan: weeklyPlan),
        WeekDayCardEdit(day: "Sunday", weeklyPlan: weeklyPlan),
      ],
    );
  }
}
