import 'package:flutter/material.dart';
import '../models/meal.dart';

class CreateMealPage extends StatefulWidget {
  const CreateMealPage({super.key});

  @override
  State<CreateMealPage> createState() => _CreateMealPageState();
}

class _CreateMealPageState extends State<CreateMealPage> {
  final addFoodNameController = TextEditingController();
  final addFoodIngredientController = TextEditingController();
  final addFoodQuantityController = TextEditingController();
  String quantityUnit = 'g';
  List<String> quantityUnits = ['ml', 'kg', 'piece', 'mg', 'g'];

  var ingredients = <Ingredient>[];

  @override
  void dispose() {
    addFoodNameController.dispose();
    addFoodIngredientController.dispose();
    addFoodQuantityController.dispose();
    super.dispose();
  }

  void cleanUpDialog() {
    Navigator.of(context).pop();
    addFoodIngredientController.clear();
    addFoodQuantityController.clear();
    addFoodNameController.clear();
    ingredients = [];
  }

  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String ingredientsErrorText = '';

  void _submit() {
    if (_formKey.currentState!.validate()) {
      var meal =
          Meal(name: addFoodNameController.text, ingredients: ingredients);
      meal.addMealToDatabase(meal);
      cleanUpDialog();
    }
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
      addFoodIngredientController.clear();
      addFoodQuantityController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      cleanUpDialog();
                    },
                    icon: const Icon(Icons.arrow_back)),
                const Text("Meal Page"),
              ],
            ),
            Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: TextFormField(
                      controller: addFoodNameController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 3, color: Colors.black),
                          ),
                          hintText: 'Meal Name'),
                      validator: (text) {
                        return validate(text);
                      },
                      onChanged: (text) => setState(() => _name = text),
                    ),
                  ),
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
                            height: 55,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
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
                            MaterialStateProperty.all<Color>(Colors.green)),
                    onPressed: addIngredientToMeal,
                    child: const Text(
                      'Add Ingredient',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _name.isNotEmpty ? _submit : null,
                    child: const Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
