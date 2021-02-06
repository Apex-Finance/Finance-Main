import 'package:Plutus/widgets/goals_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/goals.dart';
import '../widgets/goals_list_tile.dart';
import '../providers/auth.dart';

class GoalScreen extends StatelessWidget {
  static const routeName = '/goal';

  void _enterGoal(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) => GoalsForm(),
    );
  }

  @override
  Widget build(BuildContext context) {
    Goal goal; // will change to reflect DB
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
            // Do we need this? It appears everytime you switch to the Goal tab -Juan
            return Text('Loading...');
          default:
            switch (snapshot.data.docs.isEmpty) {
              case true:
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('No goals yet. Ready to add one?',
                          style: Theme.of(context).textTheme.bodyText1),
                      RaisedButton(
                          color: Theme.of(context).primaryColor,
                          textColor: Theme.of(context).canvasColor,
                          child: Text(
                            "Add Goal",
                          ),
                          onPressed: () => _enterGoal(context)),
                    ],
                  ),
                );
              default:
                print(snapshot.hasData);
                return ListView(
                  padding: EdgeInsets.all(12.0),
                  children: snapshot.data.docs.map(
                    (doc) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 8.0),
                        child: Column(
                          children: [
                            GoalsListTile(
                                //onLongPress: () {
                                /*capture info from this document into the goal object provided above
                            and offer them to either update or delete possibly*/
                                //},
                                ),
                            // TODO This is temporary. Allows me to test adding a goal
                            RaisedButton(
                                color: Theme.of(context).primaryColor,
                                textColor: Theme.of(context).canvasColor,
                                child: Text(
                                  "Add Goal",
                                ),
                                onPressed: () => _enterGoal(context)),
                          ],
                        ),
                      );
                    },
                  ).toList(),
                );
            }
        }
      },
    );
  }
}
