import 'package:flutter/material.dart';
import 'package:meal_plan_app/providers/weekly_meal_plan_provider.dart';
import 'package:meal_plan_app/widgets/meal_display_widget.dart';
import 'package:provider/provider.dart';
import '../assets/constants.dart' as constants;

class WeeklyMealPlanDisplay extends StatelessWidget {
  const WeeklyMealPlanDisplay({Key? key}) : super(key: key);

  static const List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  Widget build(BuildContext context) {
    final weeklyMealProvider =
        Provider.of<MealSelectionsProvider>(context, listen: false);

    Widget buildMealDisplay(String displayName, int dayIndex) {
      final meals = weeklyMealProvider.weeklyMeals[dayIndex];
      return Column(
        children: [
          MealDisplayWidget(
            displayName: displayName,
            breakfast: meals[constants.breakfast],
            dinner: meals[constants.lunch],
            lunch: meals[constants.dinner],
          ),
          //const SizedBox(height: 20),
        ],
      );
    }

    return Column(
      children: [
        for (int i = 0; i < daysOfWeek.length; i++)
          buildMealDisplay(daysOfWeek[i].substring(0, 3).toUpperCase(),
              getDayIndex(daysOfWeek[i])),
      ],
    );
  }

  int getDayIndex(String day) {
    switch (day) {
      case 'Monday':
        return constants.monday;
      case 'Tuesday':
        return constants.tuesday;
      case 'Wednesday':
        return constants.wednesday;
      case 'Thursday':
        return constants.thursday;
      case 'Friday':
        return constants.friday;
      case 'Saturday':
        return constants.saturday;
      default:
        return constants.sunday;
    }
  }
}
