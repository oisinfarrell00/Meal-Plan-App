import 'package:flutter/material.dart';
import 'package:meal_plan_app/providers/weekly_meal_plan_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MealDropDown extends StatefulWidget {
  List<String> items;
  int day;
  int meal;
  MealDropDown(
      {super.key, required this.items, required this.day, required this.meal});

  @override
  State<MealDropDown> createState() => _MealDropDownState();
}

class _MealDropDownState extends State<MealDropDown> {
  var meals = [];
  @override
  Widget build(BuildContext context) {
    var selectedMeals = context.watch<MealSelectionsProvider>().weeklyMeals;
    debugPrint("Selected meals: $selectedMeals");
    return Consumer<MealSelectionsProvider>(
      builder: (context, mealSelectionsProvider, _) {
        return SingleChildScrollView(
          child: MultiSelectDialogField(
            buttonText: Text("Select ${getMealNameByInt(widget.meal)}"),
            items: widget.items
                .map((String item) => MultiSelectItem(item, item))
                .toList(),
            listType: MultiSelectListType.CHIP,
            initialValue: selectedMeals[widget.day][widget.meal],
            onConfirm: (values) {
              List<String> newValues =
                  values.map((value) => value.toString()).toList();
              mealSelectionsProvider.updateMealSelection(
                  widget.day, widget.meal, newValues);
            },
          ),
        );
      },
    );
  }

  Future<dynamic> gatherIngredientsForMealPlan() async {
    final provider =
        Provider.of<MealSelectionsProvider>(context, listen: false);
    final mealsCollectionReference =
        FirebaseFirestore.instance.collection('Meals');

    var shoppingList = [];
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
                shoppingList.add(ingredients[index]['name']);
              }
            } else {
              debugPrint('No ingredients found in the document.');
            }
          }
        }
      }
      return shoppingList;
    }
  }

  Future<void> updateShoppingList(List<String> newItems) async {
    final provider =
        Provider.of<MealSelectionsProvider>(context, listen: false);
    provider.updateMealSelection(widget.day, widget.meal, newItems);
    provider.uploadWeeklyMealsToFirestore();

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

  String getMealNameByInt(int mealIndex) {
    if (mealIndex == 0) {
      return "Breakfast";
    } else if (mealIndex == 1) {
      return "Lunch";
    } else {
      return "Dinner";
    }
  }
}
