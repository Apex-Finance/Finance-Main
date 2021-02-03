import 'package:flutter/material.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';

import '../models/goals.dart';

// Form to add a new goal
class GoalsForm extends StatefulWidget {
  @override
  _GoalsFormState createState() => _GoalsFormState();
}

class _GoalsFormState extends State<GoalsForm> {
  Goal _goal = Goal(
    title: null,
    amount: null,
    goalAmount: null,
  );

  @override
  Widget build(BuildContext context) {
    return KeyboardAvoider(
      child: Container(
        child: Card(
          child: Column(
            children: <Widget>[
              DescriptionGFF(),
            ],
          ),
        ),
      ),
    );
  }
}

class DescriptionGFF extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField();
  }
}
