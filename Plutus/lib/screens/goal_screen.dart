import 'package:Plutus/widgets/debts_tab.dart';
import 'package:Plutus/widgets/goals_tab.dart';
import 'package:flutter/material.dart';

class GoalScreen extends StatelessWidget {
  static const routeName = '/goal';

  @override
  Widget build(BuildContext context) {
    Goal goal; // will change to reflect DB
    var dbRef = FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Auth>(context, listen: false).getUserId())
        .collection('Goals');
    return StreamBuilder<QuerySnapshot>(
      stream: dbRef.snapshots(),
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
          ),},};
