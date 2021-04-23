// Imported Flutter packages
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Imported Plutus files
import '../widgets/transaction_list_tile.dart';
import '../models/pie_chart.dart';
import '../widgets/goals_list_tile.dart';
import '../models/transaction.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/dashboard';

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.all(15.0),
      children: [
        Column(
          children: [
            PieChartCard(),
            BudgetLinearIndicatorCard(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TotalSpentCard(),
                TotalSavedCard(),
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

class BudgetLinearIndicatorCard extends StatelessWidget {
  const BudgetLinearIndicatorCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
          bottom: Radius.circular(20),
        ),
      ),
      child: Container(
        width: deviceSize.width * 0.85,
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
                child: StreamBuilder<QuerySnapshot>(
                  stream: null,
                  builder: (context, snapshot) {
                    return new LinearPercentIndicator(
                      width: MediaQuery.of(context).size.width * .75, // 82
                      animation: true,
                      lineHeight: 20.0,
                      animationDuration: 2500,
                      percent: 0.8,
                      center: Text("80.0%"),
                      linearStrokeCap: LinearStrokeCap.roundAll,
                      progressColor: Theme.of(context).primaryColor,
                    );
                  },
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
    );
  }
}

class TotalSavedCard extends StatelessWidget {
  const TotalSavedCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
          bottom: Radius.circular(20),
        ),
      ),
      child: Container(
        height: 90,
        width: deviceSize.width * 0.4, // 180
        child: Center(
          child: Column(
            children: [
              FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  'Total Saved',
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: Provider.of<Transactions>(context, listen: false)
                      .getMonthlyGoalTransactions(context),
                  builder: (context, snapshot) {
                    double amountSaved;
                    if (!snapshot.hasData)
                      return Container();
                    else
                      amountSaved =
                          Provider.of<Transactions>(context, listen: false)
                              .getTransactionExpenses(snapshot.data);
                    return FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        '\$${amountSaved.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class TotalSpentCard extends StatelessWidget {
  const TotalSpentCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
          bottom: Radius.circular(20),
        ),
      ),
      child: Container(
        height: 90,
        width: deviceSize.width * 0.4,
        child: Center(
          child: Column(
            children: [
              FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  'Total Spent',
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: Provider.of<Transactions>(context, listen: false)
                    .getMonthlyTransactions(context, DateTime.now())
                    .snapshots(),
                builder: (context, tranSnap) {
                  double transactionExpenses;
                  if (!tranSnap.hasData)
                    return Container();
                  else
                    transactionExpenses =
                        Provider.of<Transactions>(context, listen: false)
                            .getTransactionExpenses(tranSnap.data);
                  return FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      '\$${transactionExpenses.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
