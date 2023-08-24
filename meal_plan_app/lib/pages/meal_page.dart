import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meal_plan_app/models/meal.dart';
import 'package:meal_plan_app/pages/create_meal_page.dart';
import '../assets/constants.dart' as constants;

class MealPage extends StatefulWidget {
  const MealPage({super.key});

  @override
  State<MealPage> createState() => _MealPageState();
}

class _MealPageState extends State<MealPage> {
  var ingredients = <Ingredient>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Meals"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(99, 64, 95, 220)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: const BorderSide(color: Colors.white)))),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CreateMealPage()),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text("Create Meal"),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('Meals').snapshots(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
                          return Card(
                            child: ListTile(
                              leading: const Icon(Icons.list),
                              title: Text("${mealList[index]['name']}"),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.remove_circle_outline,
                                      color: Color.fromRGBO(220, 50, 50, 150),
                                    ),
                                    onPressed: () {
                                      Meal mealToRemove = Meal(
                                          name: mealList[index]['name'],
                                          ingredients: ingredients);
                                      mealToRemove
                                          .removeMealFromDatabase(mealToRemove);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Color.fromRGBO(50, 220, 50, 150),
                                    ),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                            ),
                          );
                        }));
                  }
                }),
          ),
        ],
      ),
    );
  }
}
