import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meal_plan_app/models/meal.dart';

class ShoppingListModel {
  bool dataFetched = false;

  List<Ingredient> shoppingList = [];
  List<Ingredient> extras = [];

  ShoppingListModel({required this.shoppingList, required this.extras});

  Future<void> updateShoppingList(
      List<Ingredient> shoppingList, List<Ingredient> extras) async {
    final shoppingListRef = FirebaseFirestore.instance
        .collection("weekly_plan")
        .doc("shopping_list");
    final shoppingListData =
        shoppingList.map((ingredient) => ingredient.toMap()).toList();
    final extrasData = extras.map((ingredient) => ingredient.toMap()).toList();

    shoppingListRef.set({
      "list": shoppingListData,
      "extras": extrasData,
    });
  }
}
