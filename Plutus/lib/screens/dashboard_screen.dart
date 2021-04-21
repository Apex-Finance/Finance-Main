import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../models/budget.dart';
import '../widgets/budget_list_tile.dart';
import '../models/transaction.dart' as Transaction;
import '../widgets/transaction_list_tile.dart';
import '../models/pie_chart.dart';
import '../widgets/goals_list_tile.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/dashboard';

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.all(15.0),
      children: [
        Column(
          children: [
            PieChartCard(),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                  bottom: Radius.circular(20),
                ),
              ),
              child: ListTile(
                title: Column(
                  children: [
                    Text(
                      'Total Budget this month',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: new LinearPercentIndicator(
                        width: MediaQuery.of(context).size.width * .80, // 82
                        animation: true,
                        lineHeight: 20.0,
                        animationDuration: 2500,
                        percent: 0.8,
                        center: Text("80.0%"),
                        linearStrokeCap: LinearStrokeCap.roundAll,
                        progressColor: Theme.of(context).primaryColor,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    /*new LinearPercentIndicator(
                      alignment: MainAxisAlignment.center,
                      width: 310.0,
                      lineHeight: 14.0,
                      percent: transactionExpenses > budget.getAmount()
                          ? 1
                          : transactionExpenses / budget.getAmount(),
                      backgroundColor: Colors.black,
                      progressColor: Colors.amber,
                    ),*/
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                      bottom: Radius.circular(20),
                    ),
                  ),
                  child: Container(
                    height: 90,
                    width: 180,
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            'Total Spent',
                            style: Theme.of(context).textTheme.headline1,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '\$500',
                            style: Theme.of(context).textTheme.headline1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                      bottom: Radius.circular(20),
                    ),
                  ),
                  child: Container(
                    height: 90,
                    width: 180, // 180
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            'Total Saved',
                            style: Theme.of(context).textTheme.headline1,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '\$500',
                            style: Theme.of(context).textTheme.headline1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            RecentTransactionsCard(3),
            UpcomingGoalCard(2),
          ],
        ),
      ],
    );
  }
}
