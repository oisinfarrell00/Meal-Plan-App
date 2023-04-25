import 'package:flutter/material.dart';

class CustomDropMenuButton extends StatefulWidget {
  const CustomDropMenuButton({super.key});

  @override
  State<CustomDropMenuButton> createState() => _CustomDropMenuButtonState();
}

class _CustomDropMenuButtonState extends State<CustomDropMenuButton> {
  String dropdownvalue = 'Item 1';

  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];
  static const contentWidth = 350.0;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: contentWidth,
        height: 50,
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: DropdownButton(
          value: dropdownvalue,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: items.map((String items) {
            return DropdownMenuItem(
              value: items,
              child: Text(items),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              dropdownvalue = newValue!;
            });
          },
        ));
  }
}
