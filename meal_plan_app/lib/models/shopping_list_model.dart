import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meal_plan_app/models/meal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/weekly_meal_plan_provider.dart';

class ShoppingListModel {
  bool dataFetched = false;

  List<Ingredient> shoppingList = [];
  List<Ingredient> extras = [];

  ShoppingListModel._privateConstructor();

  static final ShoppingListModel _instance =
      ShoppingListModel._privateConstructor();

  factory ShoppingListModel() {
    return _instance;
  }

  Future<void> updateShoppingListOnFirebase() async {
    final shoppingListRef = FirebaseFirestore.instance
        .collection("weekly_plan")
        .doc("shopping_list");
    final shoppingListData =
        shoppingList.map((ingredient) => ingredient.toMap()).toList();
    final extrasData = extras.map((ingredient) => ingredient.toMap()).toList();

    shoppingListRef.set({
      "list": shoppingListData,
      "extras": extrasData,
    });
  }

  void addToShoppingList(Ingredient ingredientToAdd) {
    shoppingList.add(ingredientToAdd);
  }

  void addToExtraList(Ingredient ingredientToAdd) {
    extras.add(ingredientToAdd);
  }

  void removeFromShoppingList(Ingredient ingredientToRemove) {
    shoppingList.remove(ingredientToRemove);
  }

  void removeFromShoppingListByIndex(int index) {
    shoppingList.removeAt(index);
  }

  void removeFromExtrasList(Ingredient ingredientToRemove) {
    extras.remove(ingredientToRemove);
  }

  void updateShoppingList(BuildContext context) async {
    List<Ingredient> currentMealPlanIngredients =
        await gatherIngredientsForMealPlan(context);
    shoppingList = generateShoppingList(currentMealPlanIngredients, extras);
  }

  Future<List<Ingredient>> gatherIngredientsForMealPlan(
      BuildContext context) async {
    final provider =
        Provider.of<MealSelectionsProvider>(context, listen: false);
    final mealsCollectionReference =
        FirebaseFirestore.instance.collection('Meals');

    List<Ingredient> ingredientsForMealsInMealPlan = [];
    for (int dayIndex = 0; dayIndex < 7; dayIndex++) {
      for (int mealIndex = 0; mealIndex < 3; mealIndex++) {
        for (int dishIndex = 0;
            dishIndex < provider.weeklyMeals[dayIndex][mealIndex].length;
            dishIndex++) {
          var mealDocumentReference = mealsCollectionReference
              .doc(provider.weeklyMeals[dayIndex][mealIndex][dishIndex]);
          var mealDocumentSnapshot = await mealDocumentReference.get();
          if (mealDocumentSnapshot.exists) {
            var mealData = mealDocumentSnapshot
                .data(); // this could be good for getting all info about the meals.
            if (mealData != null && mealData.containsKey('ingredients')) {
              var ingredients = mealData['ingredients'];
              for (int index = 0; index < ingredients.length; index++) {
                ingredientsForMealsInMealPlan.add(Ingredient(
                    name: ingredients[index]['name'],
                    quantity: ingredients[index]['quantity'],
                    quantityType: ingredients[index]['quantityType']));
              }
            } else {
              debugPrint('No ingredients found in the document.');
            }
          }
        }
      }
    }
    return ingredientsForMealsInMealPlan;
  }

  List<Ingredient> generateShoppingList(
      List<Ingredient> itemsToAdd, List<Ingredient> extras) {
    Set<Ingredient> uniqueItems = Set<Ingredient>.from(itemsToAdd);

    for (int index = 0; index < extras.length; index++) {
      if (!uniqueItems.contains(extras[index])) {
        uniqueItems.add(extras[index]);
      }
    }

    List<Ingredient> resultList = uniqueItems.toList();
    return resultList;
  }
}
