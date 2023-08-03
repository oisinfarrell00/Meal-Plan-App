import 'package:flutter/material.dart';
import 'package:meal_plan_app/pages/home_page.dart';

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
  void initState() {
    super.initState();
    addFoodIngredientController.addListener(() {
      setState(() {});
    });
    addFoodQuantityController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    addFoodIngredientController.dispose();
    addFoodQuantityController.dispose();
    super.dispose();
  }

  String validateStringInput(value) {
    final validCharacters =
        RegExp(r'^[a-zA-Z&%= éÉáÁíÍóÓúÚâÂêÊîÎôÔûÛãÃõÕçÇñÑ ]+$');
    if (value.toString().replaceAll(" ", "") == "") {
      return 'Can\'t be empty';
    }
    if (!validCharacters.hasMatch(value.toString())) {
      return 'Can\'t have special characters';
    }

    return 'valid';
  }

  String validateDoubleInput(value) {
    final doubleValue = double.tryParse(value!);
    if (doubleValue == null) {
      return 'Invalid number';
    }

    return 'valid';
  }

  void returnToMealPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  void _submit() {
    var meal = Meal(name: widget.name, ingredients: ingredients);
    meal.addMealToDatabase(meal);
    addFoodIngredientController.clear();
    addFoodQuantityController.clear();
    ingredients = [];
    returnToMealPage();
  }

  void cleanUpDialog() {
    Navigator.of(context).pop();
  }

  void addIngredientToMeal() {
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
                            validator: (value) {
                              final validCharacters = RegExp(
                                  r'^[a-zA-Z&%= éÉáÁíÍóÓúÚâÂêÊîÎôÔûÛãÃõÕçÇñÑ ]+$');
                              if (value.toString().replaceAll(" ", "") == "") {
                                return 'Can\'t be empty';
                              }
                              if (!validCharacters.hasMatch(value.toString())) {
                                return 'Can\'t have special characters';
                              }

                              return null;
                            },
                          ),
                        ),
                        Flexible(
                          flex: 3,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: addFoodQuantityController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 3, color: Colors.black),
                                ),
                                hintText: 'Quantity'),
                            validator: (value) {
                              final doubleValue = double.tryParse(value!);
                              if (doubleValue == null) {
                                return 'Invalid number';
                              }
                              return null;
                            },
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
                          backgroundColor: (validateStringInput(
                                          addFoodIngredientController.text) ==
                                      'valid' &&
                                  validateDoubleInput(
                                          addFoodQuantityController.text) ==
                                      'valid')
                              ? MaterialStateProperty.all<Color>(Colors.blue)
                              : MaterialStateProperty.all<Color>(Colors.grey)),
                      onPressed: () {
                        final isValidInput = _formKey.currentState!.validate();
                        if (isValidInput) {
                          addIngredientToMeal();
                        }
                      },
                      child: const Text(
                        'Add Ingredient',
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
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: ingredients.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                          leading: const Icon(Icons.list),
                          trailing: IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.redAccent),
                              onPressed: () {
                                setState(() {
                                  ingredients.removeAt(index);
                                });
                              }),
                          title: Text(ingredients[index].name));
                    }),
              ),
            ])));
  }
}
