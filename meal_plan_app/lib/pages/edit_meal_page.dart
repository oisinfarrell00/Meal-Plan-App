import 'package:flutter/material.dart';
import 'package:meal_plan_app/pages/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/meal.dart';

class EditMealPage extends StatefulWidget {
  const EditMealPage({super.key, required this.name});

  final String name;

  @override
  State<EditMealPage> createState() => _EditMealPageState();
}

class _EditMealPageState extends State<EditMealPage> {
  final addFoodIngredientController = TextEditingController();
  final addFoodQuantityController = TextEditingController();

  String ingredientsErrorText = '';

  String quantityUnit = 'g';
  List<String> quantityUnits = ['ml', 'kg', 'piece', 'mg', 'g'];

  List<Ingredient> ingredients = <Ingredient>[];
  bool isIngredientListEmpty = true;
  final _formKey = GlobalKey<FormState>();

  final db = FirebaseFirestore.instance;

  @override
  @override
  void initState() {
    super.initState();
    fetchMealIngredients(widget.name).then((fetchedIngredients) {
      setState(() {
        ingredients.addAll(fetchedIngredients);
        isIngredientListEmpty = ingredients.isEmpty;
      });
    });

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

  Future<List<Ingredient>> fetchMealIngredients(String mealName) async {
    List<Ingredient> ingredientsToReturn = [];
    final docRef = db.collection("Meals").doc(mealName);

    final doc = await docRef.get();
    final data = doc.data() as Map<String, dynamic>;
    List<dynamic> mealIngredientsRawData = data['ingredients'];

    for (int index = 0; index < mealIngredientsRawData.length; index++) {
      String ingredientName = mealIngredientsRawData[index]['name'];
      double ingredientQuantity = mealIngredientsRawData[index]['quantity'];
      String ingredientQuantityType =
          mealIngredientsRawData[index]['quantityType'];

      Ingredient ingredient = Ingredient(
        name: ingredientName,
        quantity: ingredientQuantity,
        quantityType: ingredientQuantityType,
      );
      ingredientsToReturn.add(ingredient);
    }

    return ingredientsToReturn;
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
        appBar: AppBar(
          title: Text("Edit ${widget.name}"),
        ),
        body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(children: [
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
                        return Card(
                          child: ListTile(
                              leading: const Icon(Icons.list),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Color.fromARGB(255, 235, 94, 84),
                                ),
                                onPressed: () {
                                  setState(() {
                                    ingredients.removeAt(index);
                                  });
                                },
                              ),
                              title: Text(ingredients[index].name)),
                        );
                      })),
            ])));
  }
}
