import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MealDisplayWidget extends StatefulWidget {
  String displayName;
  String breakfast;
  String lunch;
  String dinner;
  MealDisplayWidget(
      {super.key,
      required this.displayName,
      required this.breakfast,
      required this.lunch,
      required this.dinner});

  @override
  State<MealDisplayWidget> createState() => _MealDisplayWidgetState();
}

class _MealDisplayWidgetState extends State<MealDisplayWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 350,
        height: 60,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.lightBlue,
                    ),
                    child: Center(child: Text(widget.displayName))),
              ),
              Expanded(
                flex: 5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(widget.breakfast),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(widget.lunch),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(widget.dinner)
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
