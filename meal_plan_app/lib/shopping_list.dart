import 'package:flutter/material.dart';

List<String> shoppingList = [];

class ShoppingList extends StatefulWidget {
  const ShoppingList({super.key});

  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: shoppingList.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
                leading: const Icon(Icons.list),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Color.fromARGB(255, 235, 94, 84),
                  ),
                  onPressed: () => _removeItem(index),
                ),
                title: Text(shoppingList[index]));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        tooltip: 'Add Item',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addItem() {
    setState(() {
      shoppingList.add('New Item');
    });
  }

  void _removeItem(int index) {
    setState(() {
      shoppingList.removeAt(index);
    });
  }
}
