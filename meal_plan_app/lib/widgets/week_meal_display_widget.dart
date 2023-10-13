import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MealDisplayWidget extends StatefulWidget {
  String displayName;
  List<String> breakfast;
  List<String> lunch;
  List<String> dinner;
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
                  child: Center(child: Text(widget.displayName)),
                ),
              ),
              Expanded(
                flex: 5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: Text(
                        // change this so that it displays all meals but for now just leave it as the weekly display might be
                        // axed all together
                        widget.breakfast.isEmpty ? "-" : widget.breakfast[0],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Flexible(
                      child: Text(
                        widget.lunch.isEmpty ? "-" : widget.lunch[0],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Flexible(
                      child: Text(
                        widget.dinner.isEmpty ? "-" : widget.dinner[0],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
