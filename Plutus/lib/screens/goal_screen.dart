import 'package:flutter/material.dart';

import '../widgets/goals_list_tile.dart';

class GoalScreen extends StatelessWidget {
  static const routeName = '/goal';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Container(
            width: 250,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            bottom: 20,
          ),
          child: Text(
            "Goals & Wishes",
            style: TextStyle(
              color: Colors.amber,
              fontSize: 30,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: 5,
              itemBuilder: (context, index) => GoalsListTile()),
        ),
      ],
    );
  }
}
