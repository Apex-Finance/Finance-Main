import 'package:flutter/material.dart';

import '../models/goals.dart';

// ignore: must_be_immutable
class IndividualGoalScreen extends StatelessWidget {
  static const routeName = '/individualgoal';
  Goal goal = Goal();

  IndividualGoalScreen({@required this.goal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Text(
            "${widget.goal.getTitle}",
            style: Theme.of(context).textTheme.headline1,
          ),
          // Container(
          //   height: 100,
          //   width: 100,
          //   color: Colors.blue,
          //)
        ],
      ),
    );
  }
}
