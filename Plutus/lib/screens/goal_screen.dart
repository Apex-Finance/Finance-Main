import 'package:Plutus/widgets/debts_tab.dart';
import 'package:Plutus/widgets/goals_tab.dart';
import 'package:flutter/material.dart';

class GoalScreen extends StatelessWidget {
  static const routeName = '/goal';

  @override
  Widget build(BuildContext context) {
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
    );
  }
}
