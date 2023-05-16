import 'package:flutter/material.dart';
import '../Meal.dart';

class TextSubmitForm extends StatefulWidget {
  const TextSubmitForm({Key? key}) : super(key: key);

  @override
  State<TextSubmitForm> createState() => _TextSubmitWidgetState();
}

class _TextSubmitWidgetState extends State<TextSubmitForm> {
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
    final validCharacters = RegExp(r'^[a-zA-Z&%=]+$');
    if (text.toString().replaceAll(" ", "") == "") {
      return 'Can\'t be empty';
    }
    if (!validCharacters.hasMatch(text.toString())) {
      return 'Can\'t have special characters';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
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
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: TextFormField(
                        controller: addFoodIngredientController,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  if (addFoodIngredientController
                                      .text.isNotEmpty) {
                                    ingredients
                                        .add(addFoodIngredientController.text);
                                    addFoodIngredientController.clear();
                                  }
                                }),
                            border: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 3, color: Colors.black),
                            ),
                            hintText: 'Ingredient'),
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
      ),
    );
  }
}
