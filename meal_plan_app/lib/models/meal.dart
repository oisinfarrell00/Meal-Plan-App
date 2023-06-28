import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Meal {
  String name;
  List<Ingredient> ingredients;

  Meal({
    required this.name,
    required this.ingredients,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ingredients': ingredients,
    };
  }

  Future<void> addMealToDatabase(Meal meal) async {
    try {
      final mealRef =
          FirebaseFirestore.instance.collection("Meals").doc(meal.name);

      List<Map<String, dynamic>> ingredientsList =
          meal.ingredients.map((ingredient) {
        return {
          'name': ingredient.name,
          'quantity': ingredient.quantity,
          'quantityType': ingredient.quantityType
        };
      }).toList();

      await mealRef.set({'name': meal.name, 'ingredients': ingredientsList});
    } catch (e) {
      debugPrint("Error adding meal to database: $e");
    }
  }

  Future<void> removeMealFromDatabase(Meal meal) async {
    try {
      final mealRef =
          FirebaseFirestore.instance.collection('Meals').doc(meal.name);
      await mealRef.delete();
    } catch (e) {
      debugPrint("Error removing meal from database: $e");
    }
  }
}

class Ingredient {
  final String name;
  final double quantity;
  final String quantityType;

  Ingredient({
    required this.name,
    required this.quantity,
    required this.quantityType,
  });
}
