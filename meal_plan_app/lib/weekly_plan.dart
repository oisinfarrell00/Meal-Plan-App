import 'package:flutter/material.dart';
import 'package:meal_plan_app/drop_down_menu.dart';
import 'assets/constants.dart' as constants;

class WeeklyMealPlan extends StatefulWidget {
  const WeeklyMealPlan({super.key});

  @override
  State<WeeklyMealPlan> createState() => _WeeklyMealPlanState();
}

class _WeeklyMealPlanState extends State<WeeklyMealPlan> {
  Widget dayTile(String day) {
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
        mealTile("Breakfast"),
        mealTile("Lunch"),
        mealTile("Dinner"),
        const SizedBox(
          height: 30,
        )
      ],
    );
  }

  Widget mealTile(String meal) {
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
        const CustomDropMenuButton()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Expanded(
            flex: 1,
            child: Center(
                child: Text(
              "Weekly Meal Plan",
              style: constants.MEAL_HEADER_TEXT_STYLE,
            )),
          ),
          Expanded(
            flex: 3,
            child: Center(
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
          ),
        ],
      ),
    );
  }
}
