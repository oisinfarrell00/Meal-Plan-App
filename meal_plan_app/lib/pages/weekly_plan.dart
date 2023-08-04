import 'package:flutter/material.dart';
import 'package:meal_plan_app/widgets/day_meal_display_widget.dart';
import 'package:meal_plan_app/widgets/weekly_plan_display.dart';
import 'package:meal_plan_app/widgets/weekly_plan_selecter.dart';

class WeeklyMealPlan extends StatefulWidget {
  const WeeklyMealPlan({super.key});

  @override
  State<WeeklyMealPlan> createState() => _WeeklyMealPlanState();
}

class _WeeklyMealPlanState extends State<WeeklyMealPlan> {
  bool inEditMode = false;
  bool weeklyView = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          if (!inEditMode)
            IconButton(
              icon: weeklyView
                  ? const Icon(Icons.calendar_month)
                  : const Icon(Icons.calendar_today),
              onPressed: () {
                setState(() {
                  weeklyView = !weeklyView;
                });
              },
            ),
          IconButton(
            icon: inEditMode
                ? const Icon(Icons.done_rounded)
                : const Icon(Icons.edit_note_rounded),
            onPressed: () {
              setState(() {
                inEditMode = !inEditMode;
              });
            },
          ),
        ],
        title: const Text("Weekly Meal Plan"),
      ),
      body: inEditMode
          ? const WeeklyMealPlanSelecter()
          : weeklyView
              ? const WeeklyMealPlanDisplay()
              : const DailyMealPlanDisplay(),
    );
  }
}
