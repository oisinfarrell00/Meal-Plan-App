import 'package:flutter/material.dart';
import 'package:meal_plan_app/pages/home_page.dart';
import 'package:meal_plan_app/pages/meal_page.dart';

import '../models/meal.dart';

class AddIngredientsToMealPage extends StatefulWidget {
  const AddIngredientsToMealPage({super.key, required this.name});

  final String name;

  @override
  State<AddIngredientsToMealPage> createState() =>
      _AddIngredientsToMealPageState();
}

class _AddIngredientsToMealPageState extends State<AddIngredientsToMealPage> {
  final addFoodIngredientController = TextEditingController();
  final addFoodQuantityController = TextEditingController();
  String quantityUnit = 'g';
  List<String> quantityUnits = ['ml', 'kg', 'piece', 'mg', 'g'];

  var ingredients = <Ingredient>[];
  bool isIngredientListEmpty = true;
  final _formKey = GlobalKey<FormState>();
  String ingredientsErrorText = '';

  @override
  void dispose() {
    addFoodIngredientController.dispose();
    addFoodQuantityController.dispose();
    super.dispose();
  }

  void returnToMealPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      var meal = Meal(name: widget.name, ingredients: ingredients);
      meal.addMealToDatabase(meal);
      addFoodIngredientController.clear();
      addFoodQuantityController.clear();
      ingredients = [];
      returnToMealPage();
    }
  }

  void cleanUpDialog() {
    Navigator.of(context).pop();
  }

  String? validate(text) {
    final validCharacters = RegExp(r'^[a-zA-Z&%= ]+$');
    if (text.toString().replaceAll(" ", "") == "") {
      return 'Can\'t be empty';
    }
    if (!validCharacters.hasMatch(text.toString())) {
      return 'Can\'t have special characters';
    }

    return null;
  }

  void addIngredientToMeal() {
    // Needs validation beyond is empty
    if (addFoodIngredientController.text.isNotEmpty &&
        addFoodQuantityController.text.isNotEmpty) {
      Ingredient ingredientToAdd = Ingredient(
          name: addFoodIngredientController.text,
          quantity: double.parse(addFoodQuantityController.text),
          quantityType: quantityUnit);
      ingredients.add(ingredientToAdd);
      setState(() {
        isIngredientListEmpty = false;
      });
      addFoodIngredientController.clear();
      addFoodQuantityController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        cleanUpDialog();
                      },
                      icon: const Icon(Icons.arrow_back)),
                  const Text("Back to Meal Page"),
                ],
              ),
              Text("Add Ingredients to ${widget.name}"),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          flex: 5,
                          child: TextFormField(
                            controller: addFoodIngredientController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 3, color: Colors.black),
                                ),
                                hintText: 'Ingredient'),
                          ),
                        ),
                        Flexible(
                          flex: 3,
                          child: TextFormField(
                            controller: addFoodQuantityController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 3, color: Colors.black),
                                ),
                                hintText: 'Quantity'),
                          ),
                        ),
                        Flexible(
                            flex: 2,
                            child: Container(
                              height: 59,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: DropdownButton<String>(
                                icon: const Icon(Icons.arrow_downward),
                                value: quantityUnit,
                                items: quantityUnits
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  setState(() {
                                    quantityUnit = value!;
                                  });
                                },
                              ),
                            )),
                      ],
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue)),
                      onPressed: addIngredientToMeal,
                      child: const Text(
                        'Add Ingredients',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: !isIngredientListEmpty
                              ? MaterialStateProperty.all<Color>(Colors.green)
                              : MaterialStateProperty.all<Color>(Colors.grey)),
                      onPressed: !isIngredientListEmpty ? _submit : null,
                      child: const Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              )
            ])));
  }
}
