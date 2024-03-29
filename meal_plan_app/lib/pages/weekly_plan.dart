import 'package:flutter/material.dart';
import 'package:meal_plan_app/models/meal.dart';
import 'package:meal_plan_app/widgets/day_meal_display_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meal_plan_app/widgets/weekly_plan_display.dart';
import 'package:meal_plan_app/widgets/weekly_plan_selecter.dart';
import 'package:provider/provider.dart';

import '../models/shopping_list_model.dart';
import '../providers/weekly_meal_plan_provider.dart';

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
    final weeklyMealProvider =
        Provider.of<MealSelectionsProvider>(context, listen: false);
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
              if (inEditMode) {
                weeklyMealProvider.uploadWeeklyMealsToFirestore();
                ShoppingListModel().updateShoppingList(context);
              }
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
