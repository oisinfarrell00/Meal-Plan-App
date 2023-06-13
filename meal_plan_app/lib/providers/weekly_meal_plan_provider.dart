import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MealSelectionsProvider extends ChangeNotifier {
  List<List<String>> weeklyMeals = [
    ['-', '-', '-'], // Monday
    ['-', '-', '-'], // Tuesday
    ['-', '-', '-'], // Wednesday
    ['-', '-', '-'], // Thursday
    ['-', '-', '-'], // Friday
    ['-', '-', '-'], // Saturday
    ['-', '-', '-'], // Sunday
  ];

  MealSelectionsProvider() {
    // _fetchMealPlanFromFirestore();
  }

  Future<void> _fetchMealPlanFromFirestore() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('weekly_plan').get();

      for (final QueryDocumentSnapshot<Map<String, dynamic>> document
          in snapshot.docs) {
        final String documentId = document.id;
        final Map<String, dynamic> data = document.data();

        final List<String> meals = _deserializeMeals(data);
        final int dayIndex = _getDayIndexFromDocumentId(documentId);

        if (dayIndex != -1) {
          weeklyMeals[dayIndex] = meals;
        }
      }

      notifyListeners();
    } catch (e) {
      // Handle any error that occurred while fetching the data
      debugPrint('Error fetching meal plan: $e');
    }
  }

  void updateMealSelection(int day, int meal, newValue) {
    weeklyMeals[day][meal] = newValue;
  }

  List<String> _deserializeMeals(Map<String, dynamic> data) {
    final List<String> meals = [];

    if (data.containsKey('breakfast')) {
      meals.add(data['breakfast'] as String);
    } else {
      meals.add('');
    }

    if (data.containsKey('lunch')) {
      meals.add(data['lunch'] as String);
    } else {
      meals.add('');
    }

    if (data.containsKey('dinner')) {
      meals.add(data['dinner'] as String);
    } else {
      meals.add('');
    }

    return meals;
  }

  int _getDayIndexFromDocumentId(String documentId) {
    switch (documentId) {
      case 'monday':
        return 0;
      case 'tuesday':
        return 1;
      case 'wednesday':
        return 2;
      case 'thursday':
        return 3;
      case 'friday':
        return 4;
      case 'saturday':
        return 5;
      case 'sunday':
        return 6;
      default:
        return -1;
    }
  }
}
