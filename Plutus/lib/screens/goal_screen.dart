import 'package:flutter/material.dart';

class GoalScreen extends StatelessWidget {
  static const routeName = '/goal';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Goal Screen',
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }
}
