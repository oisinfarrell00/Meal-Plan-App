import 'package:flutter/material.dart';
import 'package:meal_plan_app/widgets/weekly_plan_display.dart';
import 'package:meal_plan_app/widgets/weekly_plan_selecter.dart';
import '../assets/constants.dart' as constants;

class WeeklyMealPlan extends StatefulWidget {
  const WeeklyMealPlan({super.key});

  @override
  State<WeeklyMealPlan> createState() => _WeeklyMealPlanState();
}

class _WeeklyMealPlanState extends State<WeeklyMealPlan> {
  bool inEditMode = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Expanded(
          flex: 2,
          child: Center(
              child: Text(
            "Weekly Meal Plan",
            style: constants.MEAL_HEADER_TEXT_STYLE,
          )),
        ),
        Expanded(
            flex: 5,
            child: inEditMode
                ? const WeeklyMealPlanSelecter()
                : const WeeklyMealPlanDisplay()),
        Expanded(
            flex: 1,
            child: SizedBox(
              width: 200,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.teal,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  onPressed: () {
                    setState(() {
                      inEditMode = !inEditMode;
                    });
                  },
                  child: Text(inEditMode ? 'Save Plan' : 'Edit Plan'),
                ),
              ),
            ))
      ],
    );
  }
}
