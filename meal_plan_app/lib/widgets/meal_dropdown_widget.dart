import 'package:flutter/material.dart';
import 'package:meal_plan_app/providers/weekly_meal_plan_provider.dart';
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
