// Imported Flutter packages
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

// Imported Plutus files
import '../widgets/goals_form.dart';
import '../widgets/goals_list_tile.dart';
import '../models/goals.dart';

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

    return StreamBuilder<QuerySnapshot>(
      stream: goalDataProvider.getUpcomingGoals(context),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          // ok to leave this waiting state since only ever waits on initial load
          case ConnectionState.waiting:
            return Center(
                // child: Text(
                //   'Loading...',
                //   style: TextStyle(
                //       fontSize: 18, color: Theme.of(context).primaryColor),
                //   textAlign: TextAlign.center,
                // ),
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
                      ElevatedButton(
                        child: Text(
                          'Add Goal',
                          style:
                              TextStyle(color: Theme.of(context).canvasColor),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                        ),
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
                          child: ElevatedButton(
                            child: Text(
                              'Add Goal',
                              style: TextStyle(
                                  color: Theme.of(context).canvasColor),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).primaryColor,
                              textStyle: TextStyle(
                                  color: Theme.of(context).canvasColor),
                            ),
                            onPressed: () => _enterGoal(context),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 25),
                        child: Card(
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
