import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MealSelectionsProvider extends ChangeNotifier {
  bool dataFetched = false;

  List<List<List<String>>> weeklyMeals = [
    [[], [], []],
    [[], [], []],
    [[], [], []],
    [[], [], []],
    [[], [], []],
    [[], [], []],
    [[], [], []]
  ];

  MealSelectionsProvider() {
    _fetchMealPlanFromFirestore();
  }

  Future<void> _fetchMealPlanFromFirestore() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('weekly_plan').get();

      for (final QueryDocumentSnapshot<Map<String, dynamic>> document
          in snapshot.docs) {
        final String documentId = document.id;
        final Map<String, dynamic> data = document.data();

        final List<List<String>> meals = _deserializeMeals(data);
        final int dayIndex = _getDayIndexFromDocumentId(documentId);

        debugPrint(meals.toString());

        if (dayIndex != -1) {
          weeklyMeals[dayIndex] = meals;
        }
      }

      notifyListeners();
      dataFetched = true;
    } catch (e) {
      // Handle any error that occurred while fetching the data
      debugPrint('Error fetching meal plan: $e');
    }
  }

  void uploadWeeklyMealsToFirestore() async {
    try {
      final CollectionReference<Map<String, dynamic>> collectionRef =
          FirebaseFirestore.instance.collection('weekly_plan');

      for (int i = 0; i < weeklyMeals.length; i++) {
        final List<List<String>> meals = weeklyMeals[i];
        final String day = _getDayFromIndex(i);

        final Map<String, dynamic> data = {
          'breakfast': meals[0],
          'lunch': meals[1],
          'dinner': meals[2],
        };

        await collectionRef.doc(day).set(data);
      }

      debugPrint('Weekly meals uploaded to Firestore successfully');
    } catch (e) {
      debugPrint('Error uploading weekly meals to Firestore: $e');
    }
  }

  String _getDayFromIndex(int index) {
    switch (index) {
      case 0:
        return 'monday';
      case 1:
        return 'tuesday';
      case 2:
        return 'wednesday';
      case 3:
        return 'thursday';
      case 4:
        return 'friday';
      case 5:
        return 'saturday';
      case 6:
        return 'sunday';
      default:
        throw Exception('Invalid day index');
    }
  }

  void updateMealSelection(int day, int meal, List<String> newDishes) {
    weeklyMeals[day][meal] = newDishes;
  }

  List<String> castDynamicListToStringList(
      Map<String, dynamic> data, String meal) {
    List<String> dynamicListAsStringList = [];
    for (int i = 0; i < data[meal].length; i++) {
      dynamicListAsStringList.add(data[meal][i].toString());
    }
    return dynamicListAsStringList;
  }

  List<List<String>> _deserializeMeals(Map<String, dynamic> data) {
    final List<List<String>> meals = [];

    if (data.containsKey('breakfast')) {
      meals.add(castDynamicListToStringList(data, 'breakfast'));
    } else {
      meals.add([]);
    }

    if (data.containsKey('lunch')) {
      meals.add(castDynamicListToStringList(data, 'lunch'));
    } else {
      meals.add([]);
    }

    if (data.containsKey('dinner')) {
      meals.add(castDynamicListToStringList(data, 'dinner'));
    } else {
      meals.add([]);
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
