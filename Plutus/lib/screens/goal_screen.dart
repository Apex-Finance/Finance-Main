import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../widgets/goals_form.dart';
import '../widgets/goals_list_tile.dart';
import '../models/goals.dart';
import '../providers/auth.dart';

class GoalScreen extends StatelessWidget {
  static const routeName = '/goal';
  void _enterGoal(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) => GoalsForm(),
    ).then(
      (newGoal) {
        if (newGoal == null) return;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var goalDataProvider = Provider.of<GoalDataProvider>(context);

    Goal goal = Goal();
    var dbRef = FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Auth>(context, listen: false).getUserId())
        .collection('Goals');
    return StreamBuilder<QuerySnapshot>(
      stream: dbRef.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: Text(
                'Loading...',
                style: TextStyle(
                    fontSize: 18, color: Theme.of(context).primaryColor),
                textAlign: TextAlign.center,
              ),
            );
          default:
            switch (snapshot.data.docs.isEmpty) {
              case true:
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'You have no goals yet.',
                        style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).primaryColor),
                        textAlign: TextAlign.center,
                      ),
                      RaisedButton(
                        child: Text('Add Goal'),
                        color: Theme.of(context).primaryColor,
                        textColor: Theme.of(context).canvasColor,
                        onPressed: () => _enterGoal(context),
                      ),
                    ],
                  ),
                );
              default:
                return Card(
                  color: Colors.grey[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        goal = goalDataProvider
                            .initializeGoal(snapshot.data.docs[index]);
                        // Sets amountSaved to 0 when goal is initialized.
                        // This is to ensure that amountSaved != null and does
                        // not get initialized everytime a Goal is built
                        if (goal.getAmount() == null) goal.setAmountSaved(0);
                        return GoalsListTile(goal);
                      },
                    ),
                  ),
                );
            }
        }
      },
    );
  }
}
