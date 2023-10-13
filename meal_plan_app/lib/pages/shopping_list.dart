import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShoppingList extends StatefulWidget {
  const ShoppingList({super.key});

  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  final TextEditingController _textEditingController = TextEditingController();
  List<dynamic> shoppingList = [];
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
              shoppingList = snapshot.data['list'];

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
                            onPressed: () => removeItemFromShoppingList(index),
                          ),
                          title: Text(shoppingList[index])),
                    );
                  });
            }
          }),
    );
  }

  Future<void> addItemToShoppingList(String newItem) async {
    final collectionReference =
        FirebaseFirestore.instance.collection('weekly_plan');
    final documentReference = collectionReference.doc('shopping_list');

    final documentSnapshot = await documentReference.get();
    if (documentSnapshot.exists) {
      final data = documentSnapshot.data();
      if (data != null &&
          data.containsKey('list') &&
          data.containsKey('extras')) {
        final list = data['list'] as List<dynamic>;
        final extras = data['extras'] as List<dynamic>;
        list.add(newItem);
        extras.add(newItem);
        await documentReference.update({'list': list, 'extras': extras});
        debugPrint('Item added successfully.');
      } else {
        debugPrint('No list found in the document.');
      }
    } else {
      debugPrint('Document does not exist.');
    }
  }

  Future<void> removeItemFromShoppingList(int index) async {
    final collectionReference =
        FirebaseFirestore.instance.collection('weekly_plan');
    final documentReference = collectionReference.doc('shopping_list');

    final documentSnapshot = await documentReference.get();
    if (documentSnapshot.exists) {
      final data = documentSnapshot.data();
      if (data != null && data.containsKey('list')) {
        final list = data['list'] as List<dynamic>;
        final extras = data['extras'] as List<dynamic>;
        if (index >= 0 && index < list.length) {
          if (extras.contains(list[index])) {
            extras.remove(list[index]);
          }
          list.removeAt(index);
          await documentReference.update({'list': list, 'extras': extras});
          debugPrint('Item removed successfully.');
        } else {
          debugPrint('Invalid index. Cannot remove item.');
        }
      } else {
        debugPrint('No list found in the document.');
      }
    } else {
      debugPrint('Document does not exist.');
    }
  }

  void _showAddItemDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Item'),
          content: TextField(
            controller: _textEditingController,
            decoration: const InputDecoration(hintText: 'Enter item name'),
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
                addItemToShoppingList(_textEditingController.text);
                _textEditingController.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
