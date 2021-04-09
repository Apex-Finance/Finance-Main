import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../widgets/goals_form.dart';
import '../widgets/goals_list_tile.dart';
import '../models/goals.dart';
import '../providers/auth.dart';

// Displays individual user goals
class GoalScreen extends StatelessWidget {
  static const routeName = '/goal';

  // Pushes the goal form onto the screen
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
        .collection('Goals')
        .orderBy('dateOfGoal', descending: false);

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
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Container(
                        width: 100,
                        child: Container(
                          child: RaisedButton(
                            child: Text('Add Goal'),
                            color: Theme.of(context).primaryColor,
                            textColor: Theme.of(context).canvasColor,
                            onPressed: () => _enterGoal(context),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 25),
                        child: Card(
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
                                return GoalsListTile(goal);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
            }
        }
      },
    );
  }
}
