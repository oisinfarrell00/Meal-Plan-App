import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Meal {
  String name;
  List<String> ingredients;

  Meal({
    required this.name,
    required this.ingredients,
  });

  static Meal fromJSON(Map<String, dynamic> json) =>
      Meal(name: json['name'], ingredients: json['ingredients']);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ingrediets': ingredients,
    };
  }

  Future<void> addMealToDatabase(Meal meal) async {
    try {
      final docUser =
          FirebaseFirestore.instance.collection("Meals").doc(meal.name);
      await docUser.set(meal.toMap());
    } catch (e) {
      debugPrint("Error adding meal to database: $e");
    }
  }

  Future<void> removeMealToDatabase(Meal meal) async {
    try {
      final docUser =
          FirebaseFirestore.instance.collection("Meals").doc(meal.name);
      debugPrint(docUser.toString());
      await docUser.delete();
    } catch (e) {
      debugPrint("Error removing meal to database: $e");
    }
  }

  Future<void> addMealsToDatabase(List<Meal> meals) async {
    try {
      final batch = FirebaseFirestore.instance.batch();
      for (var meal in meals) {
        final docUser =
            FirebaseFirestore.instance.collection("Meals").doc(meal.name);
        batch.set(docUser, meal.toMap());
      }
      await batch.commit();
    } catch (e) {
      debugPrint("Error adding meals to database: $e");
    }
  }
}
