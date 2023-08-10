import 'package:flutter/material.dart';
import 'package:meal_plan_app/widgets/meal_dropdown_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../assets/constants.dart' as constants;

class WeeklyMealPlanSelecter extends StatefulWidget {
  const WeeklyMealPlanSelecter({super.key});

  @override
  State<WeeklyMealPlanSelecter> createState() => _WeeklyMealPlanSelecterState();
}

class _WeeklyMealPlanSelecterState extends State<WeeklyMealPlanSelecter> {
  Widget dayTile(String day) {
    int dayIndex = getDayIndex(day);
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          mealTile("Breakfast", dayIndex, constants.breakfast),
          mealTile("Lunch", dayIndex, constants.lunch),
          mealTile("Dinner", dayIndex, constants.dinner),
        ],
      ),
    );
  }

  // This needs to posses the ability  to hold multiple meals.
  Widget mealTile(String meal, int dayIndex, int mealIndex) {
    return Expanded(
      child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Meals').snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            } else {
              final meals = snapshot.data!.docs;

              List<String> mealList = [];
              for (var meal in meals) {
                final data = meal.data();
                final mealName = data['name'] as String;
                mealList.add(mealName);
              }
              return MealDropDown(
                items: mealList,
                day: dayIndex,
                meal: mealIndex,
              );
            }
          }),
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

  var displayIndex = 0;
  var today = DateFormat('EEEE').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    displayIndex = getDayIndex(today);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.95,
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
              mainAxisAlignment: MainAxisAlignment.start,
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
                dayTile(getDayString(displayIndex)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
