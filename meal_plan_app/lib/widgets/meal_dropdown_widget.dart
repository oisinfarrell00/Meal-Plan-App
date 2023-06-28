import 'package:flutter/material.dart';
import 'package:meal_plan_app/providers/weekly_meal_plan_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  @override
  Widget build(BuildContext context) {
    var selectedMeals = context.watch<MealSelectionsProvider>().weeklyMeals;
    debugPrint("Selected meals: $selectedMeals");
    return Consumer<MealSelectionsProvider>(
      builder: (context, mealSelectionsProvider, _) {
        return Container(
            width: 350,
            height: 50,
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: DropdownButton(
              value: selectedMeals[widget.day][widget.meal],
              icon: const Icon(Icons.keyboard_arrow_down),
              items: widget.items.map((String item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (String? newItem) {
                setState(() {
                  // This is required to show the display value on the dropdown menu and update the meal plan. Not best
                  // practice but will do for now!
                });
                updateShoppingList(newItem!);
              },
            ));
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
        var mealDocumentReference = mealsCollectionReference
            .doc(provider.weeklyMeals[dayIndex][mealIndex]);
        var mealDocumentSnapshot = await mealDocumentReference.get();
        if (mealDocumentSnapshot.exists) {
          var mealData = mealDocumentSnapshot
              .data(); // this could be good for getting all info about the meals.
          if (mealData != null && mealData.containsKey('ingredients')) {
            var ingredients = mealData['ingredients'];
            shoppingList.addAll(ingredients);
          } else {
            debugPrint('No ingredients found in the document.');
          }
        }
      }
    }
    return shoppingList;
  }

  Future<void> updateShoppingList(String newItem) async {
    final provider =
        Provider.of<MealSelectionsProvider>(context, listen: false);
    provider.updateMealSelection(widget.day, widget.meal, newItem);

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
