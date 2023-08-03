import 'package:flutter/material.dart';
import 'package:meal_plan_app/pages/add_ingredients_to_meal_page.dart';

class CreateMealPage extends StatefulWidget {
  const CreateMealPage({super.key});

  @override
  State<CreateMealPage> createState() => _CreateMealPageState();
}

class _CreateMealPageState extends State<CreateMealPage> {
  final addFoodNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String ingredientsErrorText = '';

  bool isLowCal = false;
  bool isLowTime = false;

  @override
  void initState() {
    super.initState();
    addFoodNameController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    addFoodNameController.dispose();
    super.dispose();
  }

  void cleanUpDialog() {
    Navigator.of(context).pop();
    addFoodNameController.clear();
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

  // clean up
  Widget extraOptions() {
    return Column(children: [
      const SizedBox(height: 10),
      Row(
        children: <Widget>[
          const SizedBox(
            width: 10,
          ),
          const Text(
            'Low Calorie',
            style: TextStyle(fontSize: 17.0),
          ),
          const SizedBox(width: 10),
          Checkbox(
            value: isLowCal,
            onChanged: (bool? newBool) {
              setState(() {
                isLowCal = newBool!;
              });
            },
          ),
        ],
      ),
      Row(
        children: <Widget>[
          const SizedBox(
            width: 10,
          ),
          const Text(
            'Low Time',
            style: TextStyle(fontSize: 17.0),
          ),
          const SizedBox(width: 25),
          Checkbox(
            value: isLowTime,
            onChanged: (bool? newBool) {
              setState(() {
                isLowTime = newBool!;
              });
            },
          ),
        ],
      ),
    ]);
  }

  void moveToAddIngredientPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddIngredientsToMealPage(
                name: _name,
              )),
    );
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
                      validator: (value) {
                        final validCharacters = RegExp(r'^[a-zA-Z&%= ]+$');
                        if (value.toString().replaceAll(" ", "") == "") {
                          return 'Can\'t be empty';
                        }
                        if (!validCharacters.hasMatch(value.toString())) {
                          return 'Can\'t have special characters';
                        }

                        return null;
                      },
                      onChanged: (text) => setState(() => _name = text),
                    ),
                  ),
                  extraOptions(),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: validateStringInput(
                                    addFoodNameController.text) ==
                                'valid'
                            ? MaterialStateProperty.all<Color>(Colors.green)
                            : MaterialStateProperty.all<Color>(Colors.grey)),
                    onPressed: () {
                      final isValidName = _formKey.currentState!.validate();
                      if (isValidName) {
                        moveToAddIngredientPage();
                      }
                    },
                    child: const Text(
                      'Add Ingredients',
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
