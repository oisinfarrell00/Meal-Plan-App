import 'package:flutter/material.dart';
import 'package:meal_plan_app/providers/weekly_meal_plan_provider.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MealDropDown extends StatefulWidget {
  String value;
  List<String> items;
  final void Function(String?) onChanged;
  int day;
  int meal;
  MealDropDown(
      {super.key,
      required this.value,
      required this.items,
      required this.day,
      required this.meal,
      required this.onChanged});

  @override
  State<MealDropDown> createState() => _MealDropDownState();
}

class _MealDropDownState extends State<MealDropDown> {
  @override
  Widget build(BuildContext context) {
    var selectedMeals = context.watch<MealSelectionsProvider>().weeklyMeals;
    debugPrint(selectedMeals.toString());
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
                  widget.value = newValue!;
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
