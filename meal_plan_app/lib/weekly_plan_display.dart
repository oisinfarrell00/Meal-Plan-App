import 'package:flutter/material.dart';
import 'package:meal_plan_app/providers/weekly_meal_plan_provider.dart';
import 'package:provider/provider.dart';
import 'assets/constants.dart' as constants;

class WeeklyMealPlanDisplay extends StatefulWidget {
  const WeeklyMealPlanDisplay({super.key});

  @override
  State<WeeklyMealPlanDisplay> createState() => _WeeklyMealPlanDisplayState();
}

class _WeeklyMealPlanDisplayState extends State<WeeklyMealPlanDisplay> {
  late MealSelectionsProvider provider;

  int getDayIndex(String day) {
    switch (day) {
      case 'Monday':
        {
          return constants.monday;
        }
      case 'Tuesday':
        {
          return constants.tuesday;
        }
      case 'Wednesday':
        {
          return constants.wednesday;
        }
      case 'Thursday':
        {
          return constants.thursday;
        }
      case 'Friday':
        {
          return constants.friday;
        }
      case 'Saturday':
        {
          return constants.saturday;
        }
      default:
        {
          return constants.sunday;
        }
    }
  }

  Widget dailyMeals(String day) {
    int dayIndex = getDayIndex(day);
    return Column(
      children: [
        Text(day),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(provider.weeklyMeals[dayIndex][constants.breakfast]),
            const SizedBox(
              width: 20,
            ),
            Text(provider.weeklyMeals[dayIndex][constants.lunch]),
            const SizedBox(
              width: 20,
            ),
            Text(provider.weeklyMeals[dayIndex][constants.dinner])
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<MealSelectionsProvider>(context, listen: false);
    return Column(
      children: [
        dailyMeals("Monday"),
        const SizedBox(height: 20),
        dailyMeals("Tuesday"),
        const SizedBox(height: 20),
        dailyMeals("Wednesday"),
        const SizedBox(height: 20),
        dailyMeals("Thursday"),
        const SizedBox(height: 20),
        dailyMeals("Friday"),
        const SizedBox(height: 20),
        dailyMeals("Saturday"),
        const SizedBox(height: 20),
        dailyMeals("Sunday"),
        const SizedBox(height: 20),
      ],
    );
  }
}
