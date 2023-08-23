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
  int displayIndex = 0;
  var today = DateFormat('EEEE').format(DateTime.now());

  static const heading = TextStyle(
      fontFamily: 'Montserrat',
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.w600);

  @override
  void initState() {
    super.initState();
    displayIndex = getDayIndex(today);
  }

  @override
  Widget build(BuildContext context) {
    final weeklyMealProvider =
        Provider.of<MealSelectionsProvider>(context, listen: false);

    List<List<String>> todayMeals =
        weeklyMealProvider.weeklyMeals[displayIndex];
    List<String> breakfast = todayMeals[constants.breakfast];
    List<String> lunch = todayMeals[constants.lunch];
    List<String> dinner = todayMeals[constants.dinner];

    if (!weeklyMealProvider.dataFetched) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 30.0),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: const EdgeInsets.only(left: 20, right: 20),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.black))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
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
                        },
                        icon: const Icon(Icons.arrow_forward_ios)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      "Breakfast",
                      style: heading,
                    ),
                    getMealDisplayWidgets(breakfast),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      "Lunch",
                      style: heading,
                    ),
                    getMealDisplayWidgets(lunch),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      "Dinner",
                      style: heading,
                    ),
                    getMealDisplayWidgets(dinner),
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

  Widget getMealDisplayWidgets(List<String> strings) {
    List<Widget> list = <Widget>[];
    for (var i = 0; i < strings.length; i++) {
      list.add(Text(strings[i]));
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: list);
  }
}
