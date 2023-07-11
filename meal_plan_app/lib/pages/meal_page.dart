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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CreateMealPage()),
                          );
                        },
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
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.remove_circle_outline,
                                  color: Colors.redAccent,
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
                                  color: Colors.greenAccent,
                                ),
                                onPressed: () {},
                              ),
                            ],
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
