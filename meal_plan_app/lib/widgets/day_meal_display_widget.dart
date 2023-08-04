import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../assets/constants.dart' as constants;
import '../providers/weekly_meal_plan_provider.dart';

class DailyMealPlanDisplay extends StatefulWidget {
  const DailyMealPlanDisplay({super.key});

  @override
  State<DailyMealPlanDisplay> createState() => _DailyMealPlanDisplayState();
}

class _DailyMealPlanDisplayState extends State<DailyMealPlanDisplay> {
  var displayIndex = 0;
  var today = DateFormat('EEEE').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    displayIndex = getDayIndex(today);
  }

  @override
  Widget build(BuildContext context) {
    final weeklyMealProvider =
        Provider.of<MealSelectionsProvider>(context, listen: false);

    var todayMeals = weeklyMealProvider.weeklyMeals[displayIndex];
    String breakfast = todayMeals[constants.breakfast];
    String lunch = todayMeals[constants.lunch];
    String dinner = todayMeals[constants.dinner];

    if (!weeklyMealProvider.dataFetched) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 30.0),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        onPressed: () {
                          debugPrint("previous day");
                          setState(() {
                            displayIndex = (displayIndex - 1) % 7;
                          });
                        },
                        icon: const Icon(Icons.arrow_back_ios)),
                    Text(getDayString(displayIndex)),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            displayIndex = (displayIndex + 1) % 7;
                          });
                          debugPrint("day: $displayIndex");
                        },
                        icon: const Icon(Icons.arrow_forward_ios)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Breakfast: $breakfast"),
                    Text("Lunch: $lunch"),
                    Text("Dinner: $dinner"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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

  String getDayString(int dayIndex) {
    switch (dayIndex) {
      case constants.monday:
        return 'Monday';
      case constants.tuesday:
        return 'Tuesday';
      case constants.wednesday:
        return 'Wednesday';
      case constants.thursday:
        return 'Thursday';
      case constants.friday:
        return 'Friday';
      case constants.saturday:
        return 'Saturday';
      default:
        return 'Sunday';
    }
  }
}
