import 'package:flutter/material.dart';

import '../models/goals.dart';

class IndividualGoalScreen extends StatefulWidget {
  static const routeName = '/individualgoal';
  Goal goal = Goal();

  @override
  _IndividualGoalScreenState createState() => _IndividualGoalScreenState();
}

class _IndividualGoalScreenState extends State<IndividualGoalScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Text(
            "${widget.goal.getTitle()}",
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

/* ignore: must_be_immutable
class IndividualGoalScreen extends StatelessWidget {
  static const routeName = '/individualgoal';
  Goal goal = Goal();

  @override
  _IndividualGoalScreenState createState() => _IndividualGoalScreenState();
}

class _IndividualGoalScreenState extends State<IndividualGoalScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Text(
            "${widget.goal.getTitle()}",
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
} */
