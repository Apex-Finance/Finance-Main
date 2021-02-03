import 'package:Plutus/widgets/goals_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/goals.dart';
import '../widgets/goals_list_tile.dart';

class GoalScreen extends StatelessWidget {
  static const routeName = '/goal';

  void _enterGoal(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: null,
      builder: (_) => GoalsForm(),
    );
  }

  @override
  Widget build(BuildContext context) {
    var goalID; // will change to reflect DB

    return Container(
      child: goalID == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'No goals yet. Ready to add one?',
                    style: TextStyle(
                        fontSize: 18, color: Theme.of(context).primaryColor),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  RaisedButton(
                    child: Text('Add Goal'),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).canvasColor,
                    onPressed: () => _enterGoal(context),
                  ),
                ],
              ),
            )
          : Column(
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
                // Expanded(
                //   child: ListView.builder(
                //       shrinkWrap: true,
                //       itemCount: 5,
                //       itemBuilder: (context, index) => GoalsListTile()),
                // ),
              ],
            ),
    );
  }
}
