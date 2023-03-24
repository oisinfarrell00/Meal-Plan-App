import 'package:flutter/material.dart';

var txt = TextEditingController();

class WeeklyMealPlan extends StatefulWidget {
  const WeeklyMealPlan({super.key});

  @override
  State<WeeklyMealPlan> createState() => _WeeklyMealPlanState();
}

class _WeeklyMealPlanState extends State<WeeklyMealPlan> {
  Widget mealTile() {
    return SizedBox(
      width: 75,
      height: 50,
      child: TextField(
          controller: txt,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter a search term',
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: mealTile(),
    );
  }
}
