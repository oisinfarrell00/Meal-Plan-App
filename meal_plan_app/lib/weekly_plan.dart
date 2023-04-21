import 'package:flutter/material.dart';

var sundayBreakfastTextController = TextEditingController();
var sundayLunchTextController = TextEditingController();
var sundayDinnerTextController = TextEditingController();

List<TextEditingController> sundayTextControllers = [
  sundayBreakfastTextController,
  sundayLunchTextController,
  sundayDinnerTextController
];

var mondayBreakfastTextController = TextEditingController();
var mondayLunchTextController = TextEditingController();
var mondayDinnerTextController = TextEditingController();

List<TextEditingController> mondayTextControllers = [
  mondayBreakfastTextController,
  mondayLunchTextController,
  mondayDinnerTextController
];

var tuesdayBreakfastTextController = TextEditingController();
var tuesdayLunchTextController = TextEditingController();
var tuesdayDinnerTextController = TextEditingController();

List<TextEditingController> tuesdayTextControllers = [
  tuesdayBreakfastTextController,
  tuesdayLunchTextController,
  tuesdayDinnerTextController
];

var wednesdayBreakfastTextController = TextEditingController();
var wednesdayLunchTextController = TextEditingController();
var wednesdayDinnerTextController = TextEditingController();

List<TextEditingController> wednesdayTextControllers = [
  wednesdayBreakfastTextController,
  wednesdayLunchTextController,
  wednesdayDinnerTextController
];

var thursdayBreakfastTextController = TextEditingController();
var thursdayLunchTextController = TextEditingController();
var thursdayDinnerTextController = TextEditingController();

List<TextEditingController> thursdayTextControllers = [
  thursdayBreakfastTextController,
  thursdayLunchTextController,
  thursdayDinnerTextController
];

var fridayBreakfastTextController = TextEditingController();
var fridayLunchTextController = TextEditingController();
var fridayDinnerTextController = TextEditingController();

List<TextEditingController> fridayTextControllers = [
  fridayBreakfastTextController,
  fridayLunchTextController,
  fridayDinnerTextController
];

var saturdayBreakfastTextController = TextEditingController();
var saturdayLunchTextController = TextEditingController();
var saturdayDinnerTextController = TextEditingController();

List<TextEditingController> saturdayTextControllers = [
  saturdayBreakfastTextController,
  saturdayLunchTextController,
  saturdayDinnerTextController
];

class WeeklyMealPlan extends StatefulWidget {
  const WeeklyMealPlan({super.key});

  @override
  State<WeeklyMealPlan> createState() => _WeeklyMealPlanState();
}

class _WeeklyMealPlanState extends State<WeeklyMealPlan> {
  static const contentWidth = 350.0;
  static const mealBoxHeaderHeight = 30.0;

  static const dayHeaderTextStyle =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 30);

  static const mealHeaderTextStyle =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 20);

  Widget dayTile(String day, List<TextEditingController> controllers) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: contentWidth,
          decoration: BoxDecoration(
            color: Colors.blue,
            border: Border.all(
              color: Colors.black,
              width: 2.0,
            ),
          ),
          child: Text(
            day,
            style: dayHeaderTextStyle,
          ),
        ),
        mealTile("Breakfast", controllers[0]),
        mealTile("Lunch", controllers[1]),
        mealTile("Dinner", controllers[2]),
        const SizedBox(
          height: 30,
        )
      ],
    );
  }

  Widget mealTile(String meal, TextEditingController textEditingController) {
    return Column(
      children: [
        Container(
          width: contentWidth,
          height: mealBoxHeaderHeight,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 143, 197, 220),
            border: Border.all(
              color: Colors.black,
              width: 2.0,
            ),
          ),
          child: Text(
            meal,
            style: mealHeaderTextStyle,
          ),
        ),
        SizedBox(
          width: contentWidth,
          height: 50,
          child: TextField(
              controller: textEditingController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter a search term',
              )),
        ),
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
              style: dayHeaderTextStyle,
            )),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    dayTile("Monday", mondayTextControllers),
                    dayTile("Tuesday", tuesdayTextControllers),
                    dayTile("Wednesday", wednesdayTextControllers),
                    dayTile("Thursday", thursdayTextControllers),
                    dayTile("Friday", fridayTextControllers),
                    dayTile("Saturday", saturdayTextControllers),
                    dayTile("Sunday", sundayTextControllers)
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
