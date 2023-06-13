import 'package:flutter/material.dart';
import 'package:meal_plan_app/providers/weekly_meal_plan_provider.dart';
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
              onChanged: (String? newValue) {
                setState(() {
                  // This is required to show the display value on the dropdown menu and update the meal plan. Not best
                  // practice but will do for now!
                });
                final provider =
                    Provider.of<MealSelectionsProvider>(context, listen: false);
                provider.updateMealSelection(
                    widget.day, widget.meal, newValue!);
              },
            ));
      },
    );
  }
}
