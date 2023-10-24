import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meal_plan_app/models/shopping_list_model.dart';

import '../models/meal.dart';

class ShoppingList extends StatefulWidget {
  const ShoppingList({super.key});

  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  final TextEditingController ingredientNameController =
      TextEditingController();
  final TextEditingController ingredientTypeController =
      TextEditingController();
  final TextEditingController ingredientAmountController =
      TextEditingController();

  List<Ingredient> shoppingList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shopping List"),
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
                _showAddItemDialog();
              },
              icon: const Icon(Icons.add),
              label: const Text("Add Item"),
            ),
          )
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('weekly_plan')
              .doc('shopping_list')
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            } else {
              shoppingList = deserialize(snapshot.data['list']);

              return ListView.builder(
                  itemCount: shoppingList.length,
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
                                debugPrint(
                                    "Model contains: ${ShoppingListModel().shoppingList.toString()}");
                                ShoppingListModel()
                                    .removeFromShoppingListByIndex(index);
                                ShoppingListModel()
                                    .updateShoppingListOnFirebase();
                              }),
                          title: Text(shoppingList[index].name)),
                    );
                  });
            }
          }),
    );
  }

  List<Ingredient> deserialize(List<dynamic> data) {
    List<Ingredient> ingredients = [];
    debugPrint(data.toString());
    for (int index = 0; index < data.length; index++) {
      ingredients.add(Ingredient(
          name: data[index]['name'],
          quantity: data[index]['quantity'].toDouble(),
          quantityType: data[index]['quantityType']));
    }
    return ingredients;
  }

  void _showAddItemDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Item'),
          content: Column(
            children: [
              TextField(
                controller: ingredientNameController,
                decoration:
                    const InputDecoration(hintText: 'Enter ingredient name'),
              ),
              TextField(
                controller: ingredientAmountController,
                decoration:
                    const InputDecoration(hintText: 'Enter ingredient amount'),
              ),
              TextField(
                controller: ingredientTypeController,
                decoration:
                    const InputDecoration(hintText: 'Enter ingredient type'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                // Might need to add to extras too ?
                ShoppingListModel().addToShoppingList(Ingredient(
                    name: ingredientNameController.text,
                    quantity: 0.0,
                    quantityType: " "));
                ingredientNameController.clear();
                ingredientAmountController.clear();
                ingredientTypeController.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
