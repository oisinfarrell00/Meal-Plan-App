import 'package:flutter/material.dart';
import 'package:meal_plan_app/pages/meal_page.dart';
import 'package:meal_plan_app/pages/shopping_list_page.dart';
import 'package:meal_plan_app/pages/weekly_plan.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;
  static const List<Widget> _widgetOptions = <Widget>[
    ShoppingList(),
    WeeklyMealPlan(),
    MealPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Shopping List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_on),
            label: 'Meal Plan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood),
            label: 'Meals',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 255, 38, 0),
        onTap: _onItemTapped,
      ),
    );
  }
}
