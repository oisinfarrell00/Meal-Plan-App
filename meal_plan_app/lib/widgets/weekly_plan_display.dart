import 'package:flutter/material.dart';
import 'package:meal_plan_app/providers/weekly_meal_plan_provider.dart';
import 'package:meal_plan_app/widgets/week_meal_display_widget.dart';
import 'package:provider/provider.dart';
import '../assets/constants.dart' as constants;

class WeeklyMealPlanDisplay extends StatelessWidget {
  const WeeklyMealPlanDisplay({Key? key}) : super(key: key);

  static const TextStyle mealHeading = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

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
    final weeklyMealProvider = Provider.of<MealSelectionsProvider>(context);

    if (!weeklyMealProvider.dataFetched) {
      return const Center(child: CircularProgressIndicator());
    }

    return buildWeeklyMealPlan(context);
  }

  Widget buildWeeklyMealPlan(BuildContext context) {
    final weeklyMealProvider =
        Provider.of<MealSelectionsProvider>(context, listen: false);

    Widget buildMealDisplay(String displayName, int dayIndex) {
      var meals = weeklyMealProvider.weeklyMeals[dayIndex];
      return MealDisplayWidget(
        displayName: displayName,
        breakfast: meals[constants.breakfast],
        dinner: meals[constants.dinner],
        lunch: meals[constants.lunch],
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(children: [
          const Expanded(
            flex: 1,
            child: Text(""),
          ),
          Expanded(
            flex: 5,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Text(
                    "Breakfast",
                    style: mealHeading,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "Lunch",
                    style: mealHeading,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "Dinner",
                    style: mealHeading,
                  )
                ]),
          )
        ]),
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
