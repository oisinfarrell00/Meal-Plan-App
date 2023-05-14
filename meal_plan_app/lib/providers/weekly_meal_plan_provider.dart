import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class MealSelectionsProvider extends ChangeNotifier {
  List<List<String>> weeklyMeals = [
    ['Egg', 'Wrap', 'Curry'], // Monday
    ['Egg', 'Wrap', 'Curry'], // Tuesday
    ['Egg', 'Wrap', 'Curry'], // Wednesday
    ['Egg', 'Wrap', 'Curry'], // Thursday
    ['Egg', 'Wrap', 'Curry'], // Friday
    ['Egg', 'Wrap', 'Curry'], // Saturday
    ['Egg', 'Wrap', 'Curry'], // Sunday
  ];

  void updateMealSelection(int day, int meal, newValue) {
    weeklyMeals[day][meal] = newValue;
    debugPrint(weeklyMeals.toString());
  }
}
