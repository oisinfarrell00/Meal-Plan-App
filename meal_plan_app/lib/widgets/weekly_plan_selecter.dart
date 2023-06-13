import 'package:flutter/material.dart';
import 'package:meal_plan_app/widgets/meal_dropdown_widget.dart';
import '../assets/constants.dart' as constants;

class WeeklyMealPlanSelecter extends StatefulWidget {
  const WeeklyMealPlanSelecter({super.key});

  @override
  State<WeeklyMealPlanSelecter> createState() => _WeeklyMealPlanSelecterState();
}

class _WeeklyMealPlanSelecterState extends State<WeeklyMealPlanSelecter> {
  Widget dayTile(String day) {
    int dayIndex = getDayIndex(day);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: constants.CONTENT_WIDTH,
          decoration: BoxDecoration(
            color: Colors.blue,
            border: Border.all(
              color: Colors.black,
              width: 2.0,
            ),
          ),
          child: Text(
            day,
            style: constants.DAY_HEADER_TEXT_STYLE,
          ),
        ),
        mealTile("Breakfast", dayIndex, constants.breakfast),
        mealTile("Lunch", dayIndex, constants.lunch),
        mealTile("Dinner", dayIndex, constants.dinner),
        const SizedBox(
          height: 30,
        )
      ],
    );
  }

  Widget mealTile(String meal, int dayIndex, int mealIndex) {
    return Column(
      children: [
        Container(
          width: constants.CONTENT_WIDTH,
          height: constants.MEAL_BOX_HEIGHT,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 143, 197, 220),
            border: Border.all(
              color: Colors.black,
              width: 2.0,
            ),
          ),
          child: Text(
            meal,
            style: constants.MEAL_HEADER_TEXT_STYLE,
          ),
        ),
        MealDropDown(
          items: const [
            '-',
            'chili',
            'corn',
            'bread',
            'pasta'
          ], // This is the options for what the user can select. Must be changed
          day: dayIndex,
          meal: mealIndex,
        ),
      ],
    );
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              dayTile("Monday"),
              dayTile("Tuesday"),
              dayTile("Wednesday"),
              dayTile("Thursday"),
              dayTile("Friday"),
              dayTile("Saturday"),
              dayTile("Sunday")
            ],
          ),
        ),
      ),
    );
  }
}
