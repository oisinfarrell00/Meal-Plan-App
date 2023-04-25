import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meal_plan_app/meal.dart';
import 'assets/constants.dart' as constants;

class MealPage extends StatefulWidget {
  const MealPage({super.key});

  @override
  State<MealPage> createState() => _MealPageState();
}

class _MealPageState extends State<MealPage> {
  final addFoodNameController = TextEditingController();
  final addFoodIngredientController = TextEditingController();
  var ingredients = <String>[];

  @override
  void dispose() {
    addFoodNameController.dispose();
    addFoodIngredientController.dispose();
    super.dispose();
  }

  void cleanUpDialog() {
    Navigator.of(context).pop();
    addFoodIngredientController.clear();
    addFoodNameController.clear();
    ingredients = [];
  }

  void showAddMealDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: SizedBox(
              height: 300,
              child: Padding(
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
                        const Text("Add Meal"),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: TextField(
                        controller: addFoodNameController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 3, color: Colors.black),
                            ),
                            hintText: 'Name'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: TextField(
                        controller: addFoodIngredientController,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  ingredients
                                      .add(addFoodIngredientController.text);
                                  addFoodIngredientController.clear();
                                }),
                            border: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 3, color: Colors.black),
                            ),
                            hintText: 'Ingredient'),
                      ),
                    ),
                    SizedBox(
                      width: constants.CONTENT_WIDTH,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: () {
                          var meal = Meal(
                              name: addFoodNameController.text,
                              ingredients: ingredients);
                          meal.addMealToDatabase(meal);
                          cleanUpDialog();
                        },
                        child: const Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            flex: 1,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    "My Meals",
                    style: constants.MEAL_HEADER_TEXT_STYLE,
                  ),
                  SizedBox(
                    width: constants.CONTENT_WIDTH,
                    child: ElevatedButton(
                        onPressed: showAddMealDialog,
                        child: const Text("Add Meal")),
                  )
                ],
              ),
            )),
        Expanded(
          flex: 3,
          child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('Meals').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                } else {
                  final meals = snapshot.data.docs;

                  var mealList = [];
                  meals.forEach((meal) {
                    mealList.add(meal.data());
                  });
                  return ListView.builder(
                      itemCount: mealList.length,
                      itemBuilder: ((context, index) {
                        return ListTile(
                          leading: const Icon(Icons.list),
                          title: Text("${mealList[index]['name']}"),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.greenAccent,
                            ),
                            onPressed: () {},
                          ),
                        );
                      }));
                }
              }),
        ),
      ],
    );
  }
}
