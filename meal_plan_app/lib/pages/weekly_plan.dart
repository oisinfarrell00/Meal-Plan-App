import 'package:flutter/material.dart';
import 'package:meal_plan_app/widgets/day_meal_display_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meal_plan_app/widgets/weekly_plan_display.dart';
import 'package:meal_plan_app/widgets/weekly_plan_selecter.dart';
import 'package:provider/provider.dart';

import '../providers/weekly_meal_plan_provider.dart';

class WeeklyMealPlan extends StatefulWidget {
  const WeeklyMealPlan({super.key});

  @override
  State<WeeklyMealPlan> createState() => _WeeklyMealPlanState();
}

class _WeeklyMealPlanState extends State<WeeklyMealPlan> {
  bool inEditMode = false;
  bool weeklyView = false;

  @override
  Widget build(BuildContext context) {
    final weeklyMealProvider =
        Provider.of<MealSelectionsProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          if (!inEditMode)
            IconButton(
              icon: weeklyView
                  ? const Icon(Icons.calendar_month)
                  : const Icon(Icons.calendar_today),
              onPressed: () {
                setState(() {
                  weeklyView = !weeklyView;
                });
              },
            ),
          IconButton(
            icon: inEditMode
                ? const Icon(Icons.done_rounded)
                : const Icon(Icons.edit_note_rounded),
            onPressed: () {
              if (inEditMode) {
                weeklyMealProvider.uploadWeeklyMealsToFirestore();
                updateShoppingList();
              }
              setState(() {
                inEditMode = !inEditMode;
              });
            },
          ),
        ],
        title: const Text("Weekly Meal Plan"),
      ),
      body: inEditMode
          ? const WeeklyMealPlanSelecter()
          : weeklyView
              ? const WeeklyMealPlanDisplay()
              : const DailyMealPlanDisplay(),
    );
  }

  Future<dynamic> gatherIngredientsForMealPlan() async {
    final provider =
        Provider.of<MealSelectionsProvider>(context, listen: false);
    final mealsCollectionReference =
        FirebaseFirestore.instance.collection('Meals');

    var ingredientsForMealsInMealPlan = [];
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
                ingredientsForMealsInMealPlan.add(ingredients[index]['name']);
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

  Future<void> updateShoppingList() async {
    final shoppingListCollectionReference =
        FirebaseFirestore.instance.collection('weekly_plan');
    final shoppingListDocumentReference =
        shoppingListCollectionReference.doc('shopping_list');

    var mealPlanIngredients = await gatherIngredientsForMealPlan();

    final documentSnapshot = await shoppingListDocumentReference.get();
    if (documentSnapshot.exists) {
      final data = documentSnapshot.data();
      if (data != null && data.containsKey('list')) {
        final extras = data['extras'] as List<dynamic>;
        final shoppingList = generateShoppingList(mealPlanIngredients, extras);
        await shoppingListDocumentReference
            .set({'list': shoppingList, 'extras': extras});
        debugPrint('Items added successfully.');
      } else {
        debugPrint('No list found in the document.');
      }
    } else {
      debugPrint('Document does not exist.');
    }
  }

  List<dynamic> generateShoppingList(
      List<dynamic> itemsToAdd, List<dynamic> extras) {
    Set<dynamic> uniqueItems = Set<dynamic>.from(itemsToAdd);

    for (int index = 0; index < extras.length; index++) {
      if (!uniqueItems.contains(extras[index])) {
        uniqueItems.add(extras[index]);
      }
    }

    List<dynamic> resultList = uniqueItems.toList();
    return resultList;
  }
}
