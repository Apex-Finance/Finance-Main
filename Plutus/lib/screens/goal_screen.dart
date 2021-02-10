import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../widgets/goals_list_tile.dart';
import '../models/goals.dart';
import '../providers/auth.dart';

class GoalScreen extends StatelessWidget {
  static const routeName = '/goal';

  @override
  Widget build(BuildContext context) {
    GoalDataProvider goalDataProvider;

    Goal goal;
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
                          onPressed: () => null //_enterGoal(context),
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
                        snapshot.data.docs.map(
                          (doc) {
                            goal = goalDataProvider.initializeGoal(doc);
                          },
                        );
                        return GoalsListTile(goal);
                      },
                    ),
                  ),
                );
            }
        }
      },
    );
    /*Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DefaultTabController(
            length: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  child: TabBar(
                    indicatorColor: Theme.of(context).primaryColor,
                    labelColor: Theme.of(context).primaryColor,
                    unselectedLabelColor: Theme.of(context).primaryColor,
                    labelStyle: Theme.of(context).textTheme.headline1,
                    tabs: [
                      Tab(text: 'Goals'),
                      Tab(text: 'Debt'),
                    ],
                  ),
                ),
                Container(
                  height: screenHeight * 0.73, //height of TabBarView
                  child: TabBarView(
                    children: <Widget>[
                      GoalTab(),
                      DebtTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );*/
  }
}
